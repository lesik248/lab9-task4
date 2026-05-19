import 'package:flutter_test/flutter_test.dart';

import 'package:bus_booking_pro/features/auth/auth_state.dart';

import '../helpers/test_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    await TestStorage.tearDown();
  });

  test('rejects invalid email or short password', () async {
    final storage = await TestStorage.create();
    final auth = AuthController(storage);

    expect(await auth.signIn('not-an-email', 'okpass'), isFalse);
    expect(auth.signedIn, isFalse);

    expect(await auth.signIn('user@buses.by', '123'), isFalse);
    expect(auth.signedIn, isFalse);
  });

  test('signs in and persists the session', () async {
    final storage = await TestStorage.create();
    final auth = AuthController(storage);

    expect(await auth.signIn('user@buses.by', 'secret'), isTrue);
    expect(auth.signedIn, isTrue);
    expect(auth.state.email, 'user@buses.by');

    // A new controller against the same storage should see the session.
    final reopened = AuthController(storage);
    expect(reopened.signedIn, isTrue);
  });

  test('signOut clears the session', () async {
    final storage = await TestStorage.create();
    final auth = AuthController(storage);

    await auth.signIn('user@buses.by', 'secret');
    expect(auth.signedIn, isTrue);
    await auth.signOut();
    expect(auth.signedIn, isFalse);
  });
}
