import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:bus_booking_pro/app.dart';
import 'package:bus_booking_pro/features/app_providers.dart';
import 'package:bus_booking_pro/models/city.dart';

import '../test/helpers/test_storage.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    await TestStorage.tearDown();
  });

  testWidgets('creates a booking and removes it', (tester) async {
    final storage = await TestStorage.create();
    await storage.session().put('email', 'demo@buses.by');
    await storage.cities().put('list', [
      const City(id: 'grodno', name: 'Grodno', lat: 53.7, lon: 23.8).toJson(),
      const City(id: 'lida', name: 'Lida', lat: 53.9, lon: 25.3).toJson(),
    ]);
    await storage.cities().put('catalogue', [
      const City(id: 'grodno', name: 'Grodno', lat: 53.7, lon: 23.8).toJson(),
      const City(id: 'lida', name: 'Lida', lat: 53.9, lon: 25.3).toJson(),
    ]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [storageProvider.overrideWithValue(storage)],
        child: const BusBookingApp(),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await tester.tap(find.text('Bookings').first);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('booking_new_fab')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('booking_save_button')));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    expect(find.textContaining('Grodno'), findsWidgets);
    expect(find.textContaining('Lida'), findsWidgets);
  });
}
