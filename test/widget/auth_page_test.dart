import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bus_booking_pro/features/auth/auth_page.dart';

import '../helpers/test_app.dart';
import '../helpers/test_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    await TestStorage.tearDown();
  });

  testWidgets('renders the email + password form and submit button',
      (tester) async {
    final storage = await TestStorage.create();
    await tester.pumpWidget(
      wrapWidgetUnderTest(child: const AuthPage(), storage: storage),
    );
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Sign in'), findsWidgets);
    expect(find.byKey(const Key('auth_email_field')), findsOneWidget);
    expect(find.byKey(const Key('auth_password_field')), findsOneWidget);
    expect(find.byKey(const Key('auth_submit_button')), findsOneWidget);
  });

  testWidgets('shows an error when credentials are bad', (tester) async {
    final storage = await TestStorage.create();
    await tester.pumpWidget(
      wrapWidgetUnderTest(child: const AuthPage(), storage: storage),
    );
    await tester.pump(const Duration(milliseconds: 50));

    // Replace the demo email with one that fails validation.
    await tester.enterText(
        find.byKey(const Key('auth_email_field')), 'bad-email');
    await tester.enterText(
        find.byKey(const Key('auth_password_field')), '12');
    await tester.tap(find.byKey(const Key('auth_submit_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Invalid credentials'), findsOneWidget);
  });
}
