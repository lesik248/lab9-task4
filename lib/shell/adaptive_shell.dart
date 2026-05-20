import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../core/responsive.dart';
import '../l10n/app_localizations.dart';

class _Destination {
  final String label;
  final IconData icon;
  final String route;
  const _Destination(this.label, this.icon, this.route);
}

class AdaptiveShell extends StatelessWidget {
  const AdaptiveShell({super.key, required this.child});
  final Widget child;

  static const _routes = [
    '/home',
    '/cities',
    '/bookings',
    '/settings',
  ];

  int _indexOfLocation(String location) {
    for (var i = 0; i < _routes.length; i++) {
      if (location == _routes[i] || location.startsWith('${_routes[i]}/')) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final destinations = [
      _Destination(l.t('tab_home'), Icons.dashboard_outlined, '/home'),
      _Destination(l.t('tab_cities'), Icons.location_city_outlined, '/cities'),
      _Destination(l.t('tab_bookings'), Icons.receipt_long_outlined, '/bookings'),
      _Destination(l.t('tab_settings'), Icons.settings_outlined, '/settings'),
    ];
    final location =
        GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
    final selected = _indexOfLocation(location);

    final body = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, anim) =>
          FadeTransition(opacity: anim, child: child),
      child: KeyedSubtree(
        key: ValueKey<String>(location),
        child: child,
      ),
    );

    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        const SingleActivator(LogicalKeyboardKey.digit1, alt: true):
            _NavIntent(0),
        const SingleActivator(LogicalKeyboardKey.digit2, alt: true):
            _NavIntent(1),
        const SingleActivator(LogicalKeyboardKey.digit3, alt: true):
            _NavIntent(2),
        const SingleActivator(LogicalKeyboardKey.digit4, alt: true):
            _NavIntent(3),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _NavIntent: CallbackAction<_NavIntent>(
            onInvoke: (intent) {
              context.go(destinations[intent.index].route);
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: context.isCompact
              ? _MobileLayout(
                  destinations: destinations,
                  selected: selected,
                  body: body,
                )
              : _DesktopLayout(
                  destinations: destinations,
                  selected: selected,
                  body: body,
                ),
        ),
      ),
    );
  }
}

class _NavIntent extends Intent {
  final int index;
  const _NavIntent(this.index);
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.destinations,
    required this.selected,
    required this.body,
  });
  final List<_Destination> destinations;
  final int selected;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: body),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: (i) => context.go(destinations[i].route),
        destinations: [
          for (final d in destinations)
            NavigationDestination(
              key: Key('nav_${d.route}'),
              icon: Icon(d.icon),
              label: d.label,
            ),
        ],
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.destinations,
    required this.selected,
    required this.body,
  });
  final List<_Destination> destinations;
  final int selected;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final extended = context.isExpanded;
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: extended,
            selectedIndex: selected,
            onDestinationSelected: (i) =>
                context.go(destinations[i].route),
            labelType: extended
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.all,
            destinations: [
              for (final d in destinations)
                NavigationRailDestination(
                  icon: Icon(d.icon),
                  label: Text(d.label),
                ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: SafeArea(child: body)),
        ],
      ),
    );
  }
}
