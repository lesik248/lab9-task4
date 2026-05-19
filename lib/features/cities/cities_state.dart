import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/city.dart';
import '../../services/storage_service.dart';
import '../app_providers.dart';

class CitiesController extends StateNotifier<List<City>> {
  CitiesController(this._storage) : super(const []) {
    _load();
  }
  final StorageService _storage;

  static const _key = 'list';
  static const _catalogueKey = 'catalogue';

  Future<void> _load() async {
    try {
      final box = _storage.cities();
      final raw = box.get(_key) as List?;
      if (raw == null) {
        final catalogue = await loadCatalogue();
        state = catalogue.take(3).toList();
        await _persist();
      } else {
        state = raw
            .map((e) => City.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
    } catch (e) {
      debugPrint('CitiesController._load error: $e');
      state = const [];
    }
  }

  Future<void> _persist() async {
    try {
      await _storage.cities().put(
            _key,
            state.map((c) => c.toJson()).toList(),
          );
    } catch (e) {
      debugPrint('CitiesController._persist error: $e');
    }
  }

  Future<List<City>> loadCatalogue() async {
    try {
      final box = _storage.cities();
      final cached = box.get(_catalogueKey) as List?;
      if (cached != null) {
        return cached
            .map((e) => City.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
      final raw = await rootBundle.loadString('assets/data/cities.json');
      final parsed = (jsonDecode(raw) as List)
          .map((e) => City.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      await box.put(_catalogueKey, parsed.map((c) => c.toJson()).toList());
      return parsed;
    } catch (e) {
      debugPrint('CitiesController.loadCatalogue error: $e');
      return const [];
    }
  }

  Future<void> add(City city) async {
    if (state.any((c) => c.id == city.id)) return;
    state = [...state, city];
    await _persist();
  }

  Future<void> remove(String id) async {
    state = state.where((c) => c.id != id).toList();
    await _persist();
  }

  City? byId(String id) {
    for (final c in state) {
      if (c.id == id) return c;
    }
    return null;
  }
}

final citiesProvider =
    StateNotifierProvider<CitiesController, List<City>>((ref) {
  return CitiesController(ref.watch(storageProvider));
});
