import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/booking.dart';
import '../../services/storage_service.dart';
import '../app_providers.dart';

class BookingsController extends StateNotifier<List<Booking>> {
  BookingsController(this._storage) : super(const []) {
    _load();
  }
  final StorageService _storage;
  static const _key = 'list';

  void _load() {
    try {
      final raw = _storage.bookings().get(_key) as List?;
      if (raw == null) return;
      state = raw
          .map((e) =>
              Booking.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (e) {
      debugPrint('BookingsController._load error: $e');
    }
  }

  Future<void> _persist() async {
    try {
      await _storage.bookings().put(
            _key,
            state.map((b) => b.toJson()).toList(),
          );
    } catch (e) {
      debugPrint('BookingsController._persist error: $e');
    }
  }

  Future<Booking> add({
    required String fromCityId,
    required String toCityId,
    required DateTime date,
  }) async {
    final booking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fromCityId: fromCityId,
      toCityId: toCityId,
      date: date,
      seat: 1 + state.length % 40,
    );
    state = [booking, ...state];
    await _persist();
    return booking;
  }

  Future<void> remove(String id) async {
    state = state.where((b) => b.id != id).toList();
    await _persist();
  }
}

final bookingsProvider =
    StateNotifierProvider<BookingsController, List<Booking>>((ref) {
  return BookingsController(ref.watch(storageProvider));
});
