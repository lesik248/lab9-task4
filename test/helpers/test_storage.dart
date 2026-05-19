import 'dart:io';

import 'package:hive/hive.dart';

import 'package:bus_booking_pro/services/storage_service.dart';

/// Spins up Hive in a temp directory and opens every box. Call
/// [tearDown] from your test's tearDown to clean up.
class TestStorage {
  static Directory? _dir;

  static Future<StorageService> create() async {
    final dir = await Directory.systemTemp.createTemp('bus_booking_pro_test_');
    _dir = dir;
    Hive.init(dir.path);
    return StorageService.openAllBoxes();
  }

  static Future<void> tearDown() async {
    try {
      await Hive.close();
    } catch (_) {}
    final d = _dir;
    if (d != null && d.existsSync()) {
      try {
        d.deleteSync(recursive: true);
      } catch (_) {}
    }
    _dir = null;
  }
}
