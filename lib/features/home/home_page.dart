import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/responsive.dart';
import '../../l10n/app_localizations.dart';
import '../bookings/bookings_state.dart';
import '../cities/cities_state.dart';

class _CardSpec {
  final String title;
  final String desc;
  final IconData icon;
  final String route;
  final int? badge;
  const _CardSpec({
    required this.title,
    required this.desc,
    required this.icon,
    required this.route,
    this.badge,
  });
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final cities = ref.watch(citiesProvider);
    final bookings = ref.watch(bookingsProvider);
    final cards = [
      _CardSpec(
        title: l.t('home_card_cities'),
        desc: l.t('home_card_cities_desc'),
        icon: Icons.location_city,
        route: '/cities',
        badge: cities.length,
      ),
      _CardSpec(
        title: l.t('home_card_bookings'),
        desc: l.t('home_card_bookings_desc'),
        icon: Icons.receipt_long,
        route: '/bookings',
        badge: bookings.length,
      ),
      _CardSpec(
        title: l.t('home_card_weather'),
        desc: l.t('home_card_weather_desc'),
        icon: Icons.wb_sunny_outlined,
        route: cities.isNotEmpty
            ? '/weather/${cities.first.id}'
            : '/cities',
      ),
      _CardSpec(
        title: l.t('home_card_settings'),
        desc: l.t('home_card_settings_desc'),
        icon: Icons.settings_outlined,
        route: '/settings',
      ),
    ];

    final columns = context.gridColumns(min: 1, max: 4);

    return Scaffold(
      appBar: AppBar(title: Text(l.t('home_title'))),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(builder: (ctx, c) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: context.isCompact ? 1.6 : 1.4,
            ),
            itemCount: cards.length,
            itemBuilder: (ctx, i) {
              final spec = cards[i];
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 250 + i * 80),
                builder: (ctx, v, child) => Transform.translate(
                  offset: Offset(0, (1 - v) * 18),
                  child: Opacity(opacity: v, child: child),
                ),
                child: Card(
                  key: Key('home_card_${spec.route}'),
                  child: InkWell(
                    onTap: () => context.go(spec.route),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(spec.icon,
                                  size: 28,
                                  color: Theme.of(ctx)
                                      .colorScheme
                                      .primary),
                              const Spacer(),
                              if (spec.badge != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Theme.of(ctx)
                                        .colorScheme
                                        .primaryContainer,
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  child: Text('${spec.badge}'),
                                ),
                            ],
                          ),
                          const Spacer(),
                          Text(spec.title,
                              style: Theme.of(ctx)
                                  .textTheme
                                  .titleMedium),
                          const SizedBox(height: 4),
                          Text(spec.desc,
                              style: Theme.of(ctx)
                                  .textTheme
                                  .bodySmall),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
