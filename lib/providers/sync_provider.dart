import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/sync_service.dart';
import '../services/sync_repository.dart';
import '../services/app_database.dart';
import 'auth_provider.dart';

// Provider del SyncRepository (necesita AppDatabase)
final syncRepositoryProvider = Provider.family<SyncRepository, AppDatabase>((ref, db) {
  return SyncRepository(db: db);
});

// Provider del SyncService
final syncServiceProvider = Provider.family<SyncService, AppDatabase>((ref, db) {
  final apiService = ref.watch(apiServiceProvider);
  final repository = ref.watch(syncRepositoryProvider(db));
  return SyncService(apiService: apiService, repository: repository);
});
