import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/storage_service.dart';
import '../app_providers.dart';

class AuthSnapshot {
  final bool signedIn;
  final String? email;
  const AuthSnapshot({required this.signedIn, this.email});
}

class AuthController extends ChangeNotifier {
  AuthController(this._storage) {
    _current = _read();
  }

  final StorageService _storage;
  late AuthSnapshot _current;
  AuthSnapshot get state => _current;
  // Compatibility shorthands used by the router.
  bool get signedIn => _current.signedIn;

  AuthSnapshot _read() {
    final email = _storage.session().get('email') as String?;
    return AuthSnapshot(signedIn: email != null, email: email);
  }

  Future<bool> signIn(String email, String password) async {
    try {
      if (!email.contains('@') || password.length < 4) {
        return false;
      }
      await _storage.session().put('email', email);
      _current = _read();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('AuthController.signIn error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _storage.session().delete('email');
      _current = _read();
      notifyListeners();
    } catch (e) {
      debugPrint('AuthController.signOut error: $e');
    }
  }
}

final authStateProvider =
    ChangeNotifierProvider<AuthController>((ref) {
  return AuthController(ref.watch(storageProvider));
});

