// Tests de escenarios E2E del sistema de sincronización.
// Cubren: multi-dispositivo, conflictos de datos, y offline→online recovery.

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app_gestion_negocio/services/api_service.dart';
import 'package:app_gestion_negocio/services/sync_service.dart';
import 'package:app_gestion_negocio/services/sync_repository.dart';
import 'package:app_gestion_negocio/services/app_database.dart';

// ── Mocks / Fakes ──────────────────────────────────────────────────────────

class MockApiService extends Mock implements ApiService {}

/// Fake del repositorio que no necesita AppDatabase real.
/// Sustituye métodos de acceso a BD/prefs con implementaciones in-memory.
class FakeSyncRepository extends Fake implements SyncRepository {
  DateTime _lastSync = DateTime.fromMillisecondsSinceEpoch(0);
  List<SyncChange> localChanges = [];
  List<SyncChange> appliedChanges = [];
  bool isEmpty = false;

  @override
  AppDatabase get db => throw UnimplementedError('db no usado en tests');

  @override
  Future<DateTime> getLastSync() async => _lastSync;

  @override
  Future<void> saveLastSync(DateTime dt) async => _lastSync = dt;

  @override
  Future<void> resetLastSync() async =>
      _lastSync = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  Future<bool> isLocalDataEmpty() async => isEmpty;

  @override
  Future<List<SyncChange>> getLocalChanges(DateTime since) async => localChanges;

  @override
  Future<void> applyServerChanges(List<SyncChange> changes) async =>
      appliedChanges.addAll(changes);
}

// ── Helpers ────────────────────────────────────────────────────────────────

const _ts = '2026-04-29T12:00:00.000Z';

SyncChange _change({
  String entity = 'clientes',
  String action = 'upsert',
  String id = 'uuid-1',
  String syncId = 'sync-1',
  Map<String, dynamic>? data,
}) =>
    SyncChange(
      entityType: entity,
      action: action,
      id: id,
      syncId: syncId,
      data: data ?? {'nombre': 'Test', 'updated_at': _ts},
    );

(SyncService, MockApiService, FakeSyncRepository) _buildService() {
  final api  = MockApiService();
  final repo = FakeSyncRepository();
  final service = SyncService(apiService: api, repository: repo);
  return (service, api, repo);
}

// ── Tests ──────────────────────────────────────────────────────────────────

void main() {
  setUpAll(() {
    registerFallbackValue(DateTime.fromMillisecondsSinceEpoch(0));
    registerFallbackValue(<SyncChange>[]);
  });

  // ── Escenario 1: Multi-dispositivo ────────────────────────────────────────
  group('Multi-dispositivo', () {
    test('aplica cambios del servidor y guarda timestamp remoto', () async {
      final (service, api, repo) = _buildService();

      final remoteChange = _change(
        id: 'uuid-B',
        syncId: 'sync-B',
        data: {'nombre': 'Cliente de dispositivo B', 'updated_at': _ts},
      );

      when(() => api.sync(body: any(named: 'body'))).thenAnswer((_) async => {
        'changes': [remoteChange.toJson()],
        'timestamp': _ts,
      });

      int reloadCount = 0;
      service.onServerChangesApplied = () => reloadCount++;

      await service.syncNow();

      // Cambios del servidor aplicados
      expect(repo.appliedChanges.length, 1);
      expect(repo.appliedChanges.first.id, 'uuid-B');

      // Callback de recarga disparado
      expect(reloadCount, 1);

      // lastSync guardado con el timestamp del servidor
      expect(repo._lastSync, DateTime.parse(_ts));
    });

    test('envía cambios locales pendientes al servidor', () async {
      final (service, api, repo) = _buildService();

      repo.localChanges = [_change(id: 'uuid-local', syncId: 'sync-local')];

      when(() => api.sync(body: any(named: 'body'))).thenAnswer((_) async => {
        'changes': [],
        'timestamp': _ts,
      });

      await service.syncNow();

      final body = verify(() => api.sync(body: captureAny(named: 'body')))
          .captured
          .first as Map<String, dynamic>;
      final sent = body['changes'] as List;
      expect(sent.length, 1);
      expect((sent.first as Map)['id'], 'uuid-local');
    });

    test('no llama a onServerChangesApplied si no hay cambios remotos', () async {
      final (service, api, _) = _buildService();

      when(() => api.sync(body: any(named: 'body'))).thenAnswer((_) async => {
        'changes': [],
        'timestamp': _ts,
      });

      int reloadCount = 0;
      service.onServerChangesApplied = () => reloadCount++;

      await service.syncNow();

      expect(reloadCount, 0);
    });
  });

  // ── Escenario 2: Conflictos de datos ─────────────────────────────────────
  group('Conflictos de datos', () {
    test('aplica la versión del servidor para el mismo ID (server wins)', () async {
      final (service, api, repo) = _buildService();

      repo.localChanges = [
        _change(
          id: 'uuid-conflict',
          syncId: 'sync-local',
          data: {'nombre': 'Versión local', 'updated_at': '2026-04-29T11:00:00.000Z'},
        ),
      ];

      final serverVersion = _change(
        id: 'uuid-conflict',
        syncId: 'sync-server',
        data: {'nombre': 'Versión servidor', 'updated_at': _ts},
      );
      when(() => api.sync(body: any(named: 'body'))).thenAnswer((_) async => {
        'changes': [serverVersion.toJson()],
        'timestamp': _ts,
      });

      await service.syncNow();

      expect(repo.appliedChanges.length, 1);
      expect(repo.appliedChanges.first.syncId, 'sync-server');
      expect(repo.appliedChanges.first.data['nombre'], 'Versión servidor');
    });

    test('soft-delete del servidor prevalece sobre edición local', () async {
      final (service, api, repo) = _buildService();

      repo.localChanges = [
        _change(id: 'uuid-del', syncId: 'sync-edit',
            data: {'nombre': 'Edición local', 'deleted': false}),
      ];

      when(() => api.sync(body: any(named: 'body'))).thenAnswer((_) async => {
        'changes': [
          _change(
            id: 'uuid-del',
            syncId: 'sync-delete',
            data: {'nombre': 'Edición local', 'deleted': true, 'updated_at': _ts},
          ).toJson(),
        ],
        'timestamp': _ts,
      });

      await service.syncNow();

      expect(repo.appliedChanges.first.data['deleted'], true);
    });

    test('múltiples entidades en un solo ciclo se procesan correctamente', () async {
      final (service, api, repo) = _buildService();

      when(() => api.sync(body: any(named: 'body'))).thenAnswer((_) async => {
        'changes': [
          _change(id: 'c1', syncId: 's1', entity: 'clientes').toJson(),
          _change(id: 's1', syncId: 's2', entity: 'servicios').toJson(),
          _change(id: 'cita1', syncId: 's3', entity: 'citas').toJson(),
        ],
        'timestamp': _ts,
      });

      await service.syncNow();

      expect(repo.appliedChanges.length, 3);
      expect(repo.appliedChanges.map((c) => c.entityType).toSet(),
          {'clientes', 'servicios', 'citas'});
    });
  });

  // ── Escenario 3: Offline → Online recovery ────────────────────────────────
  group('Offline → Online recovery', () {
    test('no guarda lastSync cuando el API falla', () async {
      final (service, api, repo) = _buildService();
      final tsBefore = repo._lastSync;

      when(() => api.sync(body: any(named: 'body')))
          .thenThrow(const ApiException('Sin conexión al servidor.'));

      await service.syncNow();

      // lastSync no debe avanzar
      expect(repo._lastSync, tsBefore);
    });

    test('notifica SyncStatus.error cuando el API falla', () async {
      final (service, api, _) = _buildService();

      when(() => api.sync(body: any(named: 'body')))
          .thenThrow(const ApiException('Sin conexión al servidor.'));

      SyncStatus? lastStatus;
      service.onStatusChanged = (s, _) => lastStatus = s;

      await service.syncNow();

      expect(lastStatus, SyncStatus.error);
    });

    test('recupera y sincroniza correctamente tras reconexión', () async {
      final (service, api, repo) = _buildService();

      var callCount = 0;
      when(() => api.sync(body: any(named: 'body'))).thenAnswer((_) async {
        callCount++;
        if (callCount == 1) throw const ApiException('Sin conexión.');
        return {'changes': [], 'timestamp': _ts};
      });

      final statuses = <SyncStatus>[];
      service.onStatusChanged = (s, _) => statuses.add(s);

      // Primer intento — falla
      await service.syncNow();
      expect(statuses.last, SyncStatus.error);
      expect(repo._lastSync, DateTime.fromMillisecondsSinceEpoch(0));

      // Segundo intento — OK
      await service.syncNow();
      expect(statuses.last, SyncStatus.idle);
      expect(repo._lastSync, DateTime.parse(_ts));
    });

    test('en modo offline no llama al API', () async {
      final (service, api, _) = _buildService();
      service.setOnlineForTesting(false);

      final statuses = <SyncStatus>[];
      service.onStatusChanged = (s, _) => statuses.add(s);

      await service.syncNow();

      verifyNever(() => api.sync(body: any(named: 'body')));
      expect(statuses.last, SyncStatus.offline);
    });

    test('modo offline → online: los cambios locales pendientes se envían al volver', () async {
      final (service, api, repo) = _buildService();

      // Hay cambios locales pendientes acumulados offline
      repo.localChanges = [
        _change(id: 'uuid-offline-1', syncId: 'sync-off-1'),
        _change(id: 'uuid-offline-2', syncId: 'sync-off-2'),
      ];

      when(() => api.sync(body: any(named: 'body'))).thenAnswer((_) async => {
        'changes': [],
        'timestamp': _ts,
      });

      // Simular reconexión y sync manual
      service.setOnlineForTesting(true);
      await service.syncNow();

      final body = verify(() => api.sync(body: captureAny(named: 'body')))
          .captured
          .first as Map<String, dynamic>;
      final sent = body['changes'] as List;
      expect(sent.length, 2);
    });
  });
}
