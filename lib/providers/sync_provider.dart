import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/sync_service.dart';
import '../services/sync_repository.dart';
import '../services/app_database.dart';
import 'auth_provider.dart';

final syncRepositoryProvider = Provider.family<SyncRepository, AppDatabase>((ref, db) {
  return SyncRepository(db: db);
});

final syncServiceProvider = Provider.family<SyncService, AppDatabase>((ref, db) {
  final apiService = ref.watch(apiServiceProvider);
  final repository = ref.watch(syncRepositoryProvider(db));
  return SyncService(apiService: apiService, repository: repository);
});

// Estado del indicador visual de sync
class SyncStatusState {
  final SyncStatus status;
  final String? error;
  const SyncStatusState({this.status = SyncStatus.idle, this.error});
}

final syncStatusProvider =
    StateNotifierProvider.family<SyncStatusNotifier, SyncStatusState, AppDatabase>(
  (ref, db) {
    final service = ref.watch(syncServiceProvider(db));
    return SyncStatusNotifier(service);
  },
);

class SyncStatusNotifier extends StateNotifier<SyncStatusState> {
  SyncStatusNotifier(SyncService service) : super(const SyncStatusState()) {
    service.onStatusChanged = update;
  }

  void update(SyncStatus status, String? error) {
    state = SyncStatusState(status: status, error: error);
  }
}
