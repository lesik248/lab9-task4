import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bus_booking_pro/features/home/home_page.dart';
import 'package:bus_booking_pro/models/city.dart';
import 'package:bus_booking_pro/services/storage_service.dart';

import '../helpers/test_app.dart';
import '../helpers/test_storage.dart';

Future<StorageService> _seedCities(List<City> seed) async {
  final storage = createTestStorage();
  await storage.cities().put('list', seed.map((c) => c.toJson()).toList());
  return storage;
}

void _useDesktopViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(900, 1200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

void main() {
  testWidgets('renders all four dashboard cards', (tester) async {
    final storage = await _seedCities(const [
      City(id: 'grodno', name: 'Grodno', lat: 53.7, lon: 23.8),
    ]);
    _useDesktopViewport(tester);

    await tester.pumpWidget(
      wrapWidgetUnderTest(child: const HomePage(), storage: storage),
    );
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('Cities'), findsWidgets);
    expect(find.text('Bookings'), findsWidgets);
    expect(find.text('Weather'), findsWidgets);
    expect(find.text('Settings'), findsWidgets);
  });

  testWidgets('badge reflects the cities count', (tester) async {
    final storage = await _seedCities(const [
      City(id: 'grodno', name: 'Grodno', lat: 53.7, lon: 23.8),
      City(id: 'lida', name: 'Lida', lat: 53.9, lon: 25.3),
      City(id: 'slonim', name: 'Slonim', lat: 53.0, lon: 25.3),
    ]);
    _useDesktopViewport(tester);

    await tester.pumpWidget(
      wrapWidgetUnderTest(child: const HomePage(), storage: storage),
    );
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('3'), findsWidgets);
  });
}
