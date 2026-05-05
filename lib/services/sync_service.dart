import 'dart:async';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'api_service.dart';
import 'sync_repository.dart';

enum SyncStatus { idle, syncing, error, offline }

class SyncService {
  final ApiService apiService;
  final SyncRepository repository;

  final String deviceId = const Uuid().v4();
  Timer? _timer;
  bool _syncing = false;
  int _consecutiveErrors = 0;
  static const int _maxErrors = 5;

  SyncStatus _status = SyncStatus.idle;
  String? _lastError;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _online = true;

  // Notifica cambios del servidor para que providers recarguen
  VoidCallback? onServerChangesApplied;

  // Notifica cambios de estado de sync para la UI
  void Function(SyncStatus status, String? error)? onStatusChanged;

  SyncService({required this.apiService, required this.repository});

  void startPolling({Duration interval = const Duration(seconds: 10)}) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) => _maybeSyncOnce());
    _listenConnectivity();
    _initialSync();
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
    _connectivitySub?.cancel();
    _connectivitySub = null;
  }

  void _listenConnectivity() {
    _connectivitySub?.cancel();
    _connectivitySub = Connectivity()
        .onConnectivityChanged
        .listen((results) async {
      final wasOffline = !_online;
      _online = results.any((r) => r != ConnectivityResult.none);

      if (wasOffline && _online) {
        debugPrint('[Sync] Conexión restaurada, sincronizando inmediatamente');
        _consecutiveErrors = 0;
        await _syncOnce();
      } else if (!_online) {
        _updateStatus(SyncStatus.offline, 'Sin conexión');
      }
    });
  }

  Future<void> _initialSync() async {
    debugPrint('[Sync] isNewDatabase=${repository.db.isNewDatabase}, userId=${repository.db.userId}');
    if (repository.db.isNewDatabase) {
      await repository.resetLastSync();
      debugPrint('[Sync] BD nueva detectada (flag), lastSync reseteado a epoch');
    } else {
      final empty = await repository.isLocalDataEmpty();
      if (empty) {
        await repository.resetLastSync();
        debugPrint('[Sync] BD local vacía detectada, lastSync reseteado a epoch');
      }
    }
    await _syncOnce();
  }

  void _maybeSyncOnce() {
    if (!_online) return;
    // Backoff exponencial: si hay errores consecutivos, saltamos algunos ticks
    if (_consecutiveErrors > 0) {
      final skipTicks = min(_consecutiveErrors - 1, _maxErrors);
      // Usamos un simple contador modular para el backoff
      final waitTicks = 1 << skipTicks; // 1, 2, 4, 8, 16...
      if (DateTime.now().millisecondsSinceEpoch % (waitTicks * 10000) > 5000) {
        debugPrint('[Sync] Backoff: esperando ($waitTicks ticks entre reintentos)');
        return;
      }
    }
    _syncOnce();
  }

  Future<void> _syncOnce() async {
    if (_syncing) return;
    if (!_online) {
      _updateStatus(SyncStatus.offline, 'Sin conexión');
      return;
    }
    _syncing = true;
    _updateStatus(SyncStatus.syncing, null);

    try {
      final lastSync = await repository.getLastSync();
      final localChanges = await repository.getLocalChanges(lastSync);

      debugPrint('[Sync] Enviando ${localChanges.length} cambios locales (lastSync: $lastSync)');

      final body = {
        'device_id': deviceId,
        'last_sync': lastSync.toIso8601String(),
        'changes': localChanges.map((c) => c.toJson()).toList(),
      };

      final response = await apiService.sync(body: body);

      final serverChanges = (response['changes'] as List? ?? [])
          .map((c) => SyncChange.fromJson(c as Map<String, dynamic>))
          .toList();

      debugPrint('[Sync] Recibidos ${serverChanges.length} cambios del servidor');

      if (serverChanges.isNotEmpty) {
        await repository.applyServerChanges(serverChanges);
        onServerChangesApplied?.call();
      }

      final serverTs = response['timestamp'] as String?;
      final newLastSync = serverTs != null ? DateTime.parse(serverTs) : DateTime.now();
      await repository.saveLastSync(newLastSync);

      _consecutiveErrors = 0;
      _updateStatus(SyncStatus.idle, null);
    } catch (e, stack) {
      _consecutiveErrors++;
      debugPrint('[Sync] ERROR ($_consecutiveErrors): $e');
      debugPrint('[Sync] Stack: $stack');
      _updateStatus(SyncStatus.error, _friendlyError(e));
    } finally {
      _syncing = false;
    }
  }

  // Forzar una sincronización manual inmediata
  Future<void> syncNow() => _syncOnce();

  // Solo para tests: permite simular estado de red
  void setOnlineForTesting(bool online) => _online = online;

  SyncStatus get status => _status;
  String? get lastError => _lastError;

  void _updateStatus(SyncStatus status, String? error) {
    _status = status;
    _lastError = error;
    onStatusChanged?.call(status, error);
  }

  String _friendlyError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('socketexception') || msg.contains('connection refused')) {
      return 'Sin conexión al servidor';
    }
    if (msg.contains('timeout')) return 'Tiempo de espera agotado';
    if (msg.contains('401') || msg.contains('unauthorized')) return 'Sesión expirada';
    return 'Error de sincronización';
  }
}

class SyncChange {
  final String entityType;
  final String action;
  final String id;
  final String syncId;
  final Map<String, dynamic> data;

  SyncChange({
    required this.entityType,
    required this.action,
    required this.id,
    required this.syncId,
    required this.data,
  });

  Map<String, dynamic> toJson() => {
    'entity_type': entityType,
    'action': action,
    'id': id,
    'sync_id': syncId,
    'data': data,
  };

  factory SyncChange.fromJson(Map<String, dynamic> json) => SyncChange(
    entityType: json['entity_type'] as String,
    action: json['action'] as String,
    id: json['id'] as String,
    syncId: json['sync_id'] as String,
    data: json['data'] as Map<String, dynamic>,
  );
}
