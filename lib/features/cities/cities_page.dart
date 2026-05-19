import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/responsive.dart';
import '../../l10n/app_localizations.dart';
import '../../models/city.dart';
import 'cities_state.dart';

class CitiesPage extends ConsumerWidget {
  const CitiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final cities = ref.watch(citiesProvider);
    final controller = ref.read(citiesProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.t('cities_title')),
        actions: [
          IconButton(
            key: const Key('cities_add_button'),
            icon: const Icon(Icons.add),
            tooltip: l.t('cities_add'),
            onPressed: () => _showAddDialog(context, controller),
          ),
        ],
      ),
      body: cities.isEmpty
          ? Center(child: Text(l.t('cities_empty')))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: context.isCompact ? 480 : 360,
                mainAxisExtent: 96,
              ),
              itemCount: cities.length,
              itemBuilder: (ctx, i) {
                final c = cities[i];
                return Card(
                  key: Key('city_card_${c.id}'),
                  child: ListTile(
                    leading: const Icon(Icons.location_city),
                    title: Text(c.name),
                    subtitle:
                        Text('${c.lat.toStringAsFixed(3)}, ${c.lon.toStringAsFixed(3)}'),
                    trailing: IconButton(
                      key: Key('city_remove_${c.id}'),
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => controller.remove(c.id),
                    ),
                    onTap: () =>
                        context.go('/cities/${c.id}'),
                  ),
                );
              },
            ),
      floatingActionButton: context.isCompact
          ? FloatingActionButton(
              onPressed: () => _showAddDialog(context, controller),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Future<void> _showAddDialog(
      BuildContext context, CitiesController controller) async {
    final l = AppL10n.of(context);
    final catalogue = await controller.loadCatalogue();
    if (!context.mounted) return;
    final existing = controller.state.map((c) => c.id).toSet();
    final picks = catalogue.where((c) => !existing.contains(c.id)).toList();
    final chosen = await showDialog<City>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l.t('cities_dialog_title')),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: Text(l.t('cities_dialog_hint'),
                style: Theme.of(ctx).textTheme.bodySmall),
          ),
          if (picks.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('—'),
            ),
          for (final c in picks)
            SimpleDialogOption(
              key: Key('city_pick_${c.id}'),
              onPressed: () => Navigator.of(ctx).pop(c),
              child: Text(c.name),
            ),
        ],
      ),
    );
    if (chosen != null) {
      await controller.add(chosen);
    }
  }
}
