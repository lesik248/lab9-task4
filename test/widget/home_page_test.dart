import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bus_booking_pro/features/home/home_page.dart';
import 'package:bus_booking_pro/models/city.dart';

import '../helpers/test_app.dart';
import '../helpers/test_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    await TestStorage.tearDown();
  });

  testWidgets('renders all four dashboard cards', (tester) async {
    final storage = await TestStorage.create();
    await storage.cities().put('list', [
      const City(id: 'grodno', name: 'Grodno', lat: 53.7, lon: 23.8).toJson(),
    ]);
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(900, 1200)),
        child: wrapWidgetUnderTest(child: const HomePage(), storage: storage),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Cities'), findsWidgets);
    expect(find.text('Bookings'), findsWidgets);
    expect(find.text('Weather'), findsWidgets);
    expect(find.text('Settings'), findsWidgets);
  });

  testWidgets('badge reflects the cities count', (tester) async {
    final storage = await TestStorage.create();
    await storage.cities().put('list', [
      const City(id: 'grodno', name: 'Grodno', lat: 53.7, lon: 23.8).toJson(),
      const City(id: 'lida', name: 'Lida', lat: 53.9, lon: 25.3).toJson(),
      const City(id: 'slonim', name: 'Slonim', lat: 53.0, lon: 25.3).toJson(),
    ]);
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(900, 1200)),
        child: wrapWidgetUnderTest(child: const HomePage(), storage: storage),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('3'), findsWidgets);
  });
}
