import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/storage_service.dart';
import '../app_providers.dart';

class SettingsValue {
  final ThemeMode themeMode;
  final Locale locale;
  const SettingsValue({required this.themeMode, required this.locale});

  SettingsValue copyWith({ThemeMode? themeMode, Locale? locale}) =>
      SettingsValue(
        themeMode: themeMode ?? this.themeMode,
        locale: locale ?? this.locale,
      );
}

class SettingsController extends StateNotifier<SettingsValue> {
  SettingsController(this._storage)
      : super(_read(_storage));

  final StorageService _storage;

  static SettingsValue _read(StorageService storage) {
    final box = storage.settings();
    final tm = box.get('themeMode') as String? ?? 'system';
    final lang = box.get('lang') as String? ?? 'ru';
    return SettingsValue(
      themeMode: _parseTheme(tm),
      locale: Locale(lang),
    );
  }

  static ThemeMode _parseTheme(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String _serializeTheme(ThemeMode tm) {
    switch (tm) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _storage.settings().put('themeMode', _serializeTheme(mode));
  }

  Future<void> setLocale(Locale locale) async {
    state = state.copyWith(locale: locale);
    await _storage.settings().put('lang', locale.languageCode);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsController, SettingsValue>((ref) {
  return SettingsController(ref.watch(storageProvider));
});
