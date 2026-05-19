import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/city.dart';
import '../../models/weather.dart';
import '../../services/storage_service.dart';
import '../app_providers.dart';

class WeatherController {
  WeatherController(this._ref);
  final Ref _ref;

  Future<Weather> fetch(City city) async {
    final storage = _ref.read(storageProvider);
    final api = _ref.read(apiProvider);
    final cacheKey = 'w_${city.id}';
    try {
      final fresh = await api.fetchWeather(lat: city.lat, lon: city.lon);
      await storage.weatherCache().put(cacheKey, fresh.toJson());
      return fresh;
    } catch (e) {
      debugPrint('WeatherController.fetch fallback: $e');
      final cached = storage.weatherCache().get(cacheKey);
      if (cached is Map) {
        final w = Weather.fromJson(Map<String, dynamic>.from(cached));
        return Weather(
          tempC: w.tempC,
          humidity: w.humidity,
          description: w.description,
          isStub: true,
          forecast: w.forecast,
        );
      }
      return Weather.stub(city.lat + city.lon);
    }
  }
}

final weatherControllerProvider =
    Provider<WeatherController>((ref) => WeatherController(ref));

final cityWeatherProvider =
    FutureProvider.autoDispose.family<Weather, City>((ref, city) async {
  return ref.read(weatherControllerProvider).fetch(city);
});

// Used by tests to read directly from storage without an HTTP call.
Future<Weather?> cachedWeatherFor(StorageService storage, String cityId) async {
  final raw = storage.weatherCache().get('w_$cityId');
  if (raw is Map) {
    return Weather.fromJson(Map<String, dynamic>.from(raw));
  }
  return null;
}
