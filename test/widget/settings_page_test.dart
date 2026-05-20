import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bus_booking_pro/features/settings/settings_page.dart';
import 'package:bus_booking_pro/features/settings/settings_state.dart';

import '../helpers/test_app.dart';
import '../helpers/test_storage.dart';

void main() {
  testWidgets('toggles light theme and persists', (tester) async {
    final storage = createTestStorage();
    await tester.pumpWidget(
      wrapWidgetUnderTest(child: const SettingsPage(), storage: storage),
    );
    await tester.pump();

    await tester.tap(find.text('Light'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(storage.settings().get('themeMode'), 'light');
  });

  testWidgets('changes language to Russian', (tester) async {
    final storage = createTestStorage();
    await tester.pumpWidget(
      wrapWidgetUnderTest(child: const SettingsPage(), storage: storage),
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('lang_chip_ru')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(storage.settings().get('lang'), 'ru');
  });

  test('controller reads initial values from storage', () async {
    final storage = createTestStorage();
    await storage.settings().put('themeMode', 'dark');
    await storage.settings().put('lang', 'be');

    final ctrl = SettingsController(storage);
    expect(ctrl.state.themeMode, ThemeMode.dark);
    expect(ctrl.state.locale.languageCode, 'be');
  });
}
