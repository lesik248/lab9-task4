import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../app_providers.dart';
import '../auth/auth_state.dart';
import 'settings_state.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  static const String _appVersion = '1.0.0+1';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final settings = ref.watch(settingsProvider);
    final controller = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l.t('settings_title'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.t('settings_theme'),
              style: Theme.of(context).textTheme.titleMedium),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(
                value: ThemeMode.system,
                label: Text(l.t('settings_theme_system')),
                icon: const Icon(Icons.brightness_auto),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                label: Text(l.t('settings_theme_light')),
                icon: const Icon(Icons.light_mode),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text(l.t('settings_theme_dark')),
                icon: const Icon(Icons.dark_mode),
              ),
            ],
            selected: {settings.themeMode},
            onSelectionChanged: (sel) => controller.setThemeMode(sel.first),
          ),
          const SizedBox(height: 24),
          Text(l.t('settings_language'),
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: [
            for (final loc in AppL10n.supportedLocales)
              ChoiceChip(
                key: Key('lang_chip_${loc.languageCode}'),
                label: Text(loc.languageCode.toUpperCase()),
                selected: settings.locale.languageCode == loc.languageCode,
                onSelected: (_) => controller.setLocale(loc),
              ),
          ]),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            key: const Key('settings_clear_cache_button'),
            icon: const Icon(Icons.cleaning_services),
            label: Text(l.t('settings_clear_cache')),
            onPressed: () async {
              try {
                await ref.read(storageProvider).clearCache();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l.t('settings_cache_cleared'))),
                );
              } catch (e) {
                // ignore: avoid_print
                print('Clear cache error: $e');
              }
            },
          ),
          const SizedBox(height: 16),
          Text(l.t('settings_version', args: {'v': _appVersion})),
          const SizedBox(height: 24),
          FilledButton.tonalIcon(
            key: const Key('settings_signout_button'),
            icon: const Icon(Icons.logout),
            label: Text(l.t('settings_signout')),
            onPressed: () => ref.read(authStateProvider).signOut(),
          ),
        ],
      ),
    );
  }
}
