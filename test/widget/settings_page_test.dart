import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bus_booking_pro/features/settings/settings_page.dart';
import 'package:bus_booking_pro/features/settings/settings_state.dart';

import '../helpers/test_app.dart';
import '../helpers/test_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    await TestStorage.tearDown();
  });

  testWidgets('toggles light theme and persists', (tester) async {
    final storage = await TestStorage.create();
    await tester.pumpWidget(
      wrapWidgetUnderTest(child: const SettingsPage(), storage: storage),
    );
    await tester.pump();

    await tester.tap(find.text('Light'));
    await tester.pump();

    expect(storage.settings().get('themeMode'), 'light');
  });

  testWidgets('changes language to Russian', (tester) async {
    final storage = await TestStorage.create();
    await tester.pumpWidget(
      wrapWidgetUnderTest(child: const SettingsPage(), storage: storage),
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('lang_chip_ru')));
    await tester.pump();

    expect(storage.settings().get('lang'), 'ru');
  });

  testWidgets('controller reads initial values from storage',
      (tester) async {
    final storage = await TestStorage.create();
    await storage.settings().put('themeMode', 'dark');
    await storage.settings().put('lang', 'be');

    final ctrl = SettingsController(storage);
    expect(ctrl.state.themeMode, ThemeMode.dark);
    expect(ctrl.state.locale.languageCode, 'be');
  });
}
