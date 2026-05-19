import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'features/app_providers.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  StorageService storage;
  try {
    storage = await StorageService.init();
  } catch (e, st) {
    debugPrint('Bootstrap failed: $e\n$st');
    rethrow;
  }

  // Notification init is best-effort; failures are logged but non-fatal.
  unawaitedBootstrap(() async {
    await NotificationService.instance.init();
  });

  FlutterError.onError = (details) {
    debugPrint('FlutterError: ${details.exceptionAsString()}');
    FlutterError.presentError(details);
  };

  runApp(
    ProviderScope(
      overrides: [
        storageProvider.overrideWithValue(storage),
      ],
      child: const BusBookingApp(),
    ),
  );
}

void unawaitedBootstrap(Future<void> Function() task) {
  task().catchError((e) {
    debugPrint('Bootstrap step failed: $e');
  });
}
