import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import 'cities_state.dart';

class CityDetailPage extends ConsumerWidget {
  const CityDetailPage({super.key, required this.cityId});
  final String cityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final city = ref
        .watch(citiesProvider.notifier)
        .byId(cityId);

    return Scaffold(
      appBar: AppBar(
        title: Text(city?.name ?? l.t('city_detail_title')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/cities'),
        ),
      ),
      body: city == null
          ? const Center(child: Text('—'))
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: 'city_${city.id}',
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(city.name,
                          style: Theme.of(context).textTheme.headlineMedium),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(l.t('city_detail_coords', args: {
                    'lat': city.lat.toStringAsFixed(4),
                    'lon': city.lon.toStringAsFixed(4),
                  })),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(
                        key: Key('city_open_weather_${city.id}'),
                        icon: const Icon(Icons.cloud),
                        onPressed: () => context.go('/weather/${city.id}'),
                        label: Text(l.t('city_weather_open')),
                      ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.confirmation_number_outlined),
                        onPressed: () => context.go('/bookings'),
                        label: Text(l.t('city_book')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
