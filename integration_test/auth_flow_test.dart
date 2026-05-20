import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:bus_booking_pro/app.dart';
import 'package:bus_booking_pro/features/app_providers.dart';
import 'package:bus_booking_pro/models/city.dart';
import 'package:bus_booking_pro/services/storage_service.dart';

Future<StorageService> _bootstrap({bool signedIn = false}) async {
  final storage = StorageService.memory();
  await storage.settings().put('lang', 'en');
  if (signedIn) {
    await storage.session().put('email', 'demo@buses.by');
  }
  await storage.cities().put('list', [
    const City(id: 'grodno', name: 'Grodno', lat: 53.7, lon: 23.8).toJson(),
    const City(id: 'lida', name: 'Lida', lat: 53.9, lon: 25.3).toJson(),
  ]);
  await storage.cities().put('catalogue', [
    const City(id: 'grodno', name: 'Grodno', lat: 53.7, lon: 23.8).toJson(),
    const City(id: 'lida', name: 'Lida', lat: 53.9, lon: 25.3).toJson(),
  ]);
  return storage;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('signs in and lands on the dashboard', (tester) async {
    final storage = await _bootstrap();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [storageProvider.overrideWithValue(storage)],
        child: const BusBookingApp(),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byKey(const Key('auth_submit_button')), findsOneWidget);
    await tester.tap(find.byKey(const Key('auth_submit_button')));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text('Dashboard'), findsOneWidget);
  });

  testWidgets('redirects to /auth on sign-out', (tester) async {
    final storage = await _bootstrap(signedIn: true);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [storageProvider.overrideWithValue(storage)],
        child: const BusBookingApp(),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await tester.tap(find.text('Settings').first);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('settings_signout_button')));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byKey(const Key('auth_submit_button')), findsOneWidget);
  });
}
