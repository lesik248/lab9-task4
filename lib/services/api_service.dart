import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/weather.dart';

class ApiService {
  ApiService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 5),
              baseUrl: 'https://api.open-meteo.com/v1',
            ));

  final Dio _dio;

  Future<Weather> fetchWeather({
    required double lat,
    required double lon,
  }) async {
    try {
      final r = await _dio.get<Map<String, dynamic>>(
        '/forecast',
        queryParameters: {
          'latitude': lat,
          'longitude': lon,
          'current': 'temperature_2m,relative_humidity_2m,weather_code',
          'hourly': 'temperature_2m',
          'forecast_days': 1,
          'timezone': 'auto',
        },
      );
      final data = r.data;
      if (data == null) throw const FormatException('Empty payload');

      final current = (data['current'] as Map?) ?? const {};
      final hourly = (data['hourly'] as Map?) ?? const {};
      final temps = (hourly['temperature_2m'] as List?) ?? const [];

      final forecast = <WeatherPoint>[];
      for (var i = 0; i < temps.length && i < 24; i++) {
        forecast.add(WeatherPoint(i, (temps[i] as num).toDouble()));
      }

      return Weather(
        tempC: ((current['temperature_2m'] as num?) ?? 0).toDouble(),
        humidity: ((current['relative_humidity_2m'] as num?) ?? 0).toInt(),
        description: _describe((current['weather_code'] as num?)?.toInt() ?? 0),
        isStub: false,
        forecast: forecast,
      );
    } catch (e) {
      debugPrint('ApiService.fetchWeather error: $e');
      rethrow;
    }
  }

  static String _describe(int code) {
    if (code == 0) return 'clear';
    if (code <= 3) return 'partly cloudy';
    if (code <= 48) return 'fog';
    if (code <= 67) return 'rain';
    if (code <= 77) return 'snow';
    if (code <= 82) return 'showers';
    return 'thunderstorm';
  }
}
