import 'package:flutter_test/flutter_test.dart';

import 'package:bus_booking_pro/features/bookings/bookings_state.dart';

import '../helpers/test_storage.dart';

void main() {
  test('add prepends bookings and assigns seats', () async {
    final storage = createTestStorage();
    final ctrl = BookingsController(storage);

    final first = await ctrl.add(
      fromCityId: 'a',
      toCityId: 'b',
      date: DateTime(2026, 6, 1),
    );
    final second = await ctrl.add(
      fromCityId: 'b',
      toCityId: 'c',
      date: DateTime(2026, 6, 2),
    );

    expect(ctrl.state.length, 2);
    expect(ctrl.state.first.id, second.id);
    expect(first.seat, 1);
    expect(second.seat, 2);
  });

  test('remove deletes a booking', () async {
    final storage = createTestStorage();
    final ctrl = BookingsController(storage);

    final b = await ctrl.add(
      fromCityId: 'a',
      toCityId: 'b',
      date: DateTime(2026, 6, 1),
    );
    await ctrl.remove(b.id);
    expect(ctrl.state, isEmpty);
  });
}
