import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bus_booking_pro/features/cities/cities_page.dart';
import 'package:bus_booking_pro/models/city.dart';
import 'package:bus_booking_pro/services/storage_service.dart';

import '../helpers/test_app.dart';
import '../helpers/test_storage.dart';

Future<StorageService> _seed(
  List<City> seed, {
  List<City>? catalogue,
}) async {
  final storage = createTestStorage();
  await storage.cities().put('list', seed.map((c) => c.toJson()).toList());
  await storage.cities().put(
        'catalogue',
        (catalogue ?? seed).map((c) => c.toJson()).toList(),
      );
  return storage;
}

void main() {
  testWidgets('shows seeded cities from storage', (tester) async {
    final storage = await _seed(const [
      City(id: 'grodno', name: 'Grodno', lat: 53.7, lon: 23.8),
      City(id: 'lida', name: 'Lida', lat: 53.9, lon: 25.3),
    ]);

    await tester.pumpWidget(
      wrapWidgetUnderTest(child: const CitiesPage(), storage: storage),
    );
    await tester.pump();

    expect(find.text('Grodno'), findsOneWidget);
    expect(find.text('Lida'), findsOneWidget);
  });

  testWidgets('remove icon deletes a city', (tester) async {
    final storage = await _seed(const [
      City(id: 'grodno', name: 'Grodno', lat: 53.7, lon: 23.8),
    ]);

    await tester.pumpWidget(
      wrapWidgetUnderTest(child: const CitiesPage(), storage: storage),
    );
    await tester.pump();

    expect(find.text('Grodno'), findsOneWidget);
    await tester.tap(find.byKey(const Key('city_remove_grodno')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Grodno'), findsNothing);
  });

  testWidgets('add dialog only offers cities that are not yet selected',
      (tester) async {
    final storage = await _seed(
      const [
        City(id: 'grodno', name: 'Grodno', lat: 53.7, lon: 23.8),
      ],
      catalogue: const [
        City(id: 'grodno', name: 'Grodno', lat: 53.7, lon: 23.8),
        City(id: 'lida', name: 'Lida', lat: 53.9, lon: 25.3),
      ],
    );

    await tester.pumpWidget(
      wrapWidgetUnderTest(child: const CitiesPage(), storage: storage),
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('cities_add_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byKey(const Key('city_pick_grodno')), findsNothing);
    expect(find.byKey(const Key('city_pick_lida')), findsOneWidget);
  });
}
