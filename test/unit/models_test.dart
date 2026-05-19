import 'package:flutter_test/flutter_test.dart';

import 'package:bus_booking_pro/models/booking.dart';
import 'package:bus_booking_pro/models/city.dart';
import 'package:bus_booking_pro/models/weather.dart';

void main() {
  group('City', () {
    test('serializes and deserializes', () {
      const c = City(id: 'grodno', name: 'Гродно', lat: 53.68, lon: 23.82);
      final json = c.toJson();
      final back = City.fromJson(json);
      expect(back.id, c.id);
      expect(back.name, c.name);
      expect(back.lat, closeTo(c.lat, 1e-6));
      expect(back.lon, closeTo(c.lon, 1e-6));
    });

    test('equality is based on id', () {
      expect(
        const City(id: 'a', name: 'A', lat: 0, lon: 0) ==
            const City(id: 'a', name: 'Aprime', lat: 1, lon: 1),
        isTrue,
      );
    });
  });

  group('Booking', () {
    test('round-trips through JSON', () {
      final b = Booking(
        id: 'b1',
        fromCityId: 'a',
        toCityId: 'b',
        date: DateTime.utc(2026, 5, 19),
        seat: 7,
      );
      final json = b.toJson();
      final back = Booking.fromJson(json);
      expect(back.id, 'b1');
      expect(back.fromCityId, 'a');
      expect(back.toCityId, 'b');
      expect(back.date, DateTime.utc(2026, 5, 19));
      expect(back.seat, 7);
    });
  });

  group('Weather stub', () {
    test('produces 24 hourly forecast points', () {
      final w = Weather.stub(53.6 + 23.8);
      expect(w.isStub, isTrue);
      expect(w.forecast.length, 24);
    });

    test('survives JSON round-trip', () {
      final w = Weather.stub(10.5);
      final back = Weather.fromJson(w.toJson());
      expect(back.tempC, w.tempC);
      expect(back.humidity, w.humidity);
      expect(back.forecast.length, w.forecast.length);
    });
  });
}
