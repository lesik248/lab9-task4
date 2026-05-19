import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageBoxes {
  static const session = 'session';
  static const cities = 'cities';
  static const bookings = 'bookings';
  static const weatherCache = 'weather_cache';
  static const settings = 'settings';
}

class StorageService {
  /// Production constructor (called by [init]).
  StorageService();

  /// Test entrypoint: open all boxes against an already-initialised Hive.
  static Future<StorageService> openAllBoxes() async {
    await Future.wait([
      Hive.openBox(StorageBoxes.session),
      Hive.openBox(StorageBoxes.cities),
      Hive.openBox(StorageBoxes.bookings),
      Hive.openBox(StorageBoxes.weatherCache),
      Hive.openBox(StorageBoxes.settings),
    ]);
    return StorageService();
  }

  static Future<StorageService> init() async {
    try {
      await Hive.initFlutter('bus_booking_pro');
    } catch (e) {
      debugPrint('Hive init fallback: $e');
      Hive.init('.');
    }
    return openAllBoxes();
  }

  Box session() => Hive.box(StorageBoxes.session);
  Box cities() => Hive.box(StorageBoxes.cities);
  Box bookings() => Hive.box(StorageBoxes.bookings);
  Box weatherCache() => Hive.box(StorageBoxes.weatherCache);
  Box settings() => Hive.box(StorageBoxes.settings);

  Future<void> clearCache() async {
    await weatherCache().clear();
  }
}
