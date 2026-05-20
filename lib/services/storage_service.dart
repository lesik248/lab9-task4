import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageBoxes {
  static const session = 'session';
  static const cities = 'cities';
  static const bookings = 'bookings';
  static const weatherCache = 'weather_cache';
  static const settings = 'settings';
}

/// Thin key-value abstraction over a backing store. The production
/// implementation wraps Hive; tests use the in-memory variant.
abstract class KVBox {
  dynamic get(String key);
  Future<void> put(String key, dynamic value);
  Future<void> delete(String key);
  Future<void> clear();
}

class _HiveBox implements KVBox {
  _HiveBox(this._box);
  final Box _box;

  @override
  dynamic get(String key) => _box.get(key);

  @override
  Future<void> put(String key, dynamic value) => _box.put(key, value);

  @override
  Future<void> delete(String key) => _box.delete(key);

  @override
  Future<void> clear() => _box.clear().then((_) {});
}

class _MemoryBox implements KVBox {
  final Map<String, dynamic> _data = {};

  @override
  dynamic get(String key) => _data[key];

  @override
  Future<void> put(String key, dynamic value) async {
    _data[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _data.remove(key);
  }

  @override
  Future<void> clear() async {
    _data.clear();
  }
}

class StorageService {
  StorageService._({
    required KVBox session,
    required KVBox cities,
    required KVBox bookings,
    required KVBox weatherCache,
    required KVBox settings,
  })  : _session = session,
        _cities = cities,
        _bookings = bookings,
        _weatherCache = weatherCache,
        _settings = settings;

  final KVBox _session;
  final KVBox _cities;
  final KVBox _bookings;
  final KVBox _weatherCache;
  final KVBox _settings;

  KVBox session() => _session;
  KVBox cities() => _cities;
  KVBox bookings() => _bookings;
  KVBox weatherCache() => _weatherCache;
  KVBox settings() => _settings;

  /// Production constructor — opens every Hive box.
  static Future<StorageService> init() async {
    try {
      await Hive.initFlutter('bus_booking_pro');
    } catch (e) {
      debugPrint('Hive init fallback: $e');
      Hive.init('.');
    }
    final boxes = await Future.wait([
      Hive.openBox(StorageBoxes.session),
      Hive.openBox(StorageBoxes.cities),
      Hive.openBox(StorageBoxes.bookings),
      Hive.openBox(StorageBoxes.weatherCache),
      Hive.openBox(StorageBoxes.settings),
    ]);
    return StorageService._(
      session: _HiveBox(boxes[0]),
      cities: _HiveBox(boxes[1]),
      bookings: _HiveBox(boxes[2]),
      weatherCache: _HiveBox(boxes[3]),
      settings: _HiveBox(boxes[4]),
    );
  }

  /// In-memory variant used by tests — no disk I/O, no fake-clock issues.
  factory StorageService.memory() => StorageService._(
        session: _MemoryBox(),
        cities: _MemoryBox(),
        bookings: _MemoryBox(),
        weatherCache: _MemoryBox(),
        settings: _MemoryBox(),
      );

  Future<void> clearCache() => _weatherCache.clear();
}
