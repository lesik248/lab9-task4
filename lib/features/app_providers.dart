import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api_service.dart';
import '../services/storage_service.dart';

final storageProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('storageProvider must be overridden in ProviderScope');
});

final apiProvider = Provider<ApiService>((ref) => ApiService());
