import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/auth_state.dart';
import '../features/auth/auth_page.dart';
import '../features/home/home_page.dart';
import '../features/cities/cities_page.dart';
import '../features/cities/city_detail_page.dart';
import '../features/bookings/bookings_page.dart';
import '../features/weather/weather_page.dart';
import '../features/settings/settings_page.dart';
import '../shell/adaptive_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.read(authStateProvider);
  return GoRouter(
    initialLocation: '/home',
    refreshListenable: auth,
    redirect: (context, state) {
      final signedIn = auth.signedIn;
      final atAuth = state.matchedLocation == '/auth';
      if (!signedIn && !atAuth) return '/auth';
      if (signedIn && atAuth) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/auth',
        name: 'auth',
        pageBuilder: (ctx, st) =>
            const NoTransitionPage(child: AuthPage()),
      ),
      ShellRoute(
        builder: (ctx, state, child) => AdaptiveShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (ctx, st) =>
                const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path: '/cities',
            name: 'cities',
            pageBuilder: (ctx, st) =>
                const NoTransitionPage(child: CitiesPage()),
            routes: [
              GoRoute(
                path: ':id',
                name: 'city',
                pageBuilder: (ctx, st) => MaterialPage(
                  child: CityDetailPage(cityId: st.pathParameters['id']!),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/weather/:id',
            name: 'weather',
            pageBuilder: (ctx, st) => MaterialPage(
              child: WeatherPage(cityId: st.pathParameters['id']!),
            ),
          ),
          GoRoute(
            path: '/bookings',
            name: 'bookings',
            pageBuilder: (ctx, st) =>
                const NoTransitionPage(child: BookingsPage()),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (ctx, st) =>
                const NoTransitionPage(child: SettingsPage()),
          ),
        ],
      ),
    ],
  );
});
