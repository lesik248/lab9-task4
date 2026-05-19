import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bus_booking_pro/features/app_providers.dart';
import 'package:bus_booking_pro/l10n/app_localizations.dart';
import 'package:bus_booking_pro/services/storage_service.dart';

/// Wraps [child] in a minimal MaterialApp + ProviderScope ready for widget
/// tests, using an already-prepared [StorageService].
Widget wrapWidgetUnderTest({
  required Widget child,
  required StorageService storage,
  Locale locale = const Locale('en'),
}) {
  return ProviderScope(
    overrides: [
      storageProvider.overrideWithValue(storage),
    ],
    child: MaterialApp(
      locale: locale,
      supportedLocales: AppL10n.supportedLocales,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: child,
    ),
  );
}
