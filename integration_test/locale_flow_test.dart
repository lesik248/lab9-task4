import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:bus_booking_pro/app.dart';
import 'package:bus_booking_pro/features/app_providers.dart';
import 'package:bus_booking_pro/services/storage_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('switches UI language to Belarusian', (tester) async {
    final storage = StorageService.memory();
    await storage.settings().put('lang', 'en');
    await storage.session().put('email', 'demo@buses.by');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [storageProvider.overrideWithValue(storage)],
        child: const BusBookingApp(),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await tester.tap(find.byKey(const Key('home_card_/settings')));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await tester.tap(find.byKey(const Key('lang_chip_be')));
    await tester.pumpAndSettle();

    expect(find.text('Налады'), findsWidgets);
  });
}
