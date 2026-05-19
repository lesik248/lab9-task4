import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../models/city.dart';
import '../../models/weather.dart';
import '../cities/cities_state.dart';
import 'weather_state.dart';

class WeatherPage extends ConsumerWidget {
  const WeatherPage({super.key, required this.cityId});
  final String cityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final City? city = ref.read(citiesProvider.notifier).byId(cityId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            l.t('weather_title', args: {'city': city?.name ?? ''})),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/cities'),
        ),
      ),
      body: city == null
          ? const Center(child: Text('—'))
          : ref.watch(cityWeatherProvider(city)).when(
                data: (w) => _WeatherView(weather: w),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                    child: Text(l.t('error_generic',
                        args: {'e': e.toString()}))),
              ),
    );
  }
}

class _WeatherView extends StatelessWidget {
  const _WeatherView({required this.weather});
  final Weather weather;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 350),
      tween: Tween(begin: 0, end: 1),
      builder: (ctx, v, child) =>
          Opacity(opacity: v, child: child),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.t('weather_temp', args: {
              't': weather.tempC.toStringAsFixed(1),
            })),
            const SizedBox(height: 6),
            Text(l.t('weather_humidity', args: {'h': weather.humidity})),
            const SizedBox(height: 6),
            Text(l.t('weather_desc', args: {'d': weather.description})),
            if (weather.isStub) ...[
              const SizedBox(height: 8),
              Text(
                l.t('weather_offline'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 24),
            Text(l.t('weather_chart_title'),
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Expanded(
              child: _WeatherChart(points: weather.forecast),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherChart extends StatelessWidget {
  const _WeatherChart({required this.points});
  final List<WeatherPoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const SizedBox.shrink();
    }
    final spots = points
        .map((p) => FlSpot(p.hourOffset.toDouble(), p.tempC))
        .toList();
    final cs = Theme.of(context).colorScheme;
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: const FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            color: cs.primary,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: cs.primary.withOpacity(0.18),
            ),
          ),
        ],
      ),
    );
  }
}
