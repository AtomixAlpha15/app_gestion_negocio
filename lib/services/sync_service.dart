import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'api_service.dart';
import 'sync_repository.dart';

class SyncService {
  final ApiService apiService;
  final SyncRepository repository;

  final String deviceId = const Uuid().v4();
  Timer? _timer;
  bool _syncing = false;

  // Se llama tras aplicar cambios del servidor para que los providers recarguen
  VoidCallback? onServerChangesApplied;

  SyncService({required this.apiService, required this.repository});

  void startPolling({Duration interval = const Duration(seconds: 10)}) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) => _syncOnce());
    // Si la BD es nueva (archivo no existía), forzar descarga completa
    _initialSync();
  }

  Future<void> _initialSync() async {
    // Usar el flag isNewDatabase (capturado al construir AppDatabase, antes
    // de que ningún provider toque la BD). El chequeo de archivo en runtime
    // no es fiable porque los providers/MainShell ya han forzado a Drift a
    // crear el archivo vía onCreate antes de que lleguemos aquí.
    debugPrint('[Sync] isNewDatabase=${repository.db.isNewDatabase}, userId=${repository.db.userId}');
    if (repository.db.isNewDatabase) {
      await repository.resetLastSync();
      debugPrint('[Sync] BD nueva detectada (flag), lastSync reseteado a epoch');
    } else {
      // Salvaguarda extra: si por cualquier motivo el flag fuera incorrecto
      // pero la BD local no tiene datos, también forzar descarga completa.
      final empty = await repository.isLocalDataEmpty();
      if (empty) {
        await repository.resetLastSync();
        debugPrint('[Sync] BD local vacía detectada, lastSync reseteado a epoch');
      }
    }
    await _syncOnce();
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _syncOnce() async {
    if (_syncing) return;
    _syncing = true;

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

      // Usar el timestamp DEL SERVIDOR para evitar problemas de relojes
      // desincronizados (cliente adelantado pierde cambios; cliente atrasado
      // duplica cambios). Fallback a now() si el servidor no lo devuelve.
      final serverTs = response['timestamp'] as String?;
      final newLastSync = serverTs != null
          ? DateTime.parse(serverTs)
          : DateTime.now();
      await repository.saveLastSync(newLastSync);
    } catch (e, stack) {
      debugPrint('[Sync] ERROR: $e');
      debugPrint('[Sync] Stack: $stack');
    } finally {
      _syncing = false;
    }
  }

  // Forzar una sincronización manual inmediata
  Future<void> syncNow() => _syncOnce();
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
