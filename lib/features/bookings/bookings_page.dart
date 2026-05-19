import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../models/city.dart';
import '../../services/notification_service.dart';
import '../cities/cities_state.dart';
import 'bookings_state.dart';

class BookingsPage extends ConsumerWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final bookings = ref.watch(bookingsProvider);
    final cities = ref.watch(citiesProvider);
    final df = DateFormat('yyyy-MM-dd');

    String label(String id) =>
        cities.firstWhere((c) => c.id == id, orElse: () => const City(
              id: '?',
              name: '—',
              lat: 0,
              lon: 0,
            )).name;

    return Scaffold(
      appBar: AppBar(title: Text(l.t('bookings_title'))),
      body: bookings.isEmpty
          ? Center(child: Text(l.t('bookings_empty')))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemBuilder: (ctx, i) {
                final b = bookings[i];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Card(
                    key: Key('booking_card_${b.id}'),
                    child: ListTile(
                      title: Text(
                          '${label(b.fromCityId)} → ${label(b.toCityId)}'),
                      subtitle: Text(
                          '${df.format(b.date)}  •  seat ${b.seat}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => ref
                            .read(bookingsProvider.notifier)
                            .remove(b.id),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemCount: bookings.length,
            ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('booking_new_fab'),
        icon: const Icon(Icons.add),
        label: Text(l.t('bookings_new')),
        onPressed: () => _showNew(context, ref),
      ),
    );
  }

  Future<void> _showNew(BuildContext context, WidgetRef ref) async {
    final cities = ref.read(citiesProvider);
    if (cities.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least two cities first.')),
      );
      return;
    }
    final l = AppL10n.of(context);
    City fromCity = cities.first;
    City toCity = cities.last;
    DateTime date = DateTime.now().add(const Duration(days: 1));

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setState) {
          return AlertDialog(
            title: Text(l.t('bookings_new')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<City>(
                  key: const Key('booking_from_dd'),
                  value: fromCity,
                  decoration: InputDecoration(labelText: l.t('bookings_from')),
                  items: [
                    for (final c in cities)
                      DropdownMenuItem(value: c, child: Text(c.name)),
                  ],
                  onChanged: (v) => setState(() => fromCity = v ?? fromCity),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<City>(
                  key: const Key('booking_to_dd'),
                  value: toCity,
                  decoration: InputDecoration(labelText: l.t('bookings_to')),
                  items: [
                    for (final c in cities)
                      DropdownMenuItem(value: c, child: Text(c.name)),
                  ],
                  onChanged: (v) => setState(() => toCity = v ?? toCity),
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: Text(
                        '${l.t('bookings_date')}: ${DateFormat('yyyy-MM-dd').format(date)}'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: date,
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 1)),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) setState(() => date = picked);
                    },
                    child: const Icon(Icons.calendar_today),
                  ),
                ]),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                key: const Key('booking_save_button'),
                onPressed: () async {
                  final created =
                      await ref.read(bookingsProvider.notifier).add(
                            fromCityId: fromCity.id,
                            toCityId: toCity.id,
                            date: date,
                          );
                  if (!ctx.mounted) return;
                  Navigator.of(ctx).pop();
                  await NotificationService.instance.notify(
                    context: context,
                    title: l.t('notification_booked'),
                    body: l.t('notification_booked_body', args: {
                      'from': fromCity.name,
                      'to': toCity.name,
                      'date':
                          DateFormat('yyyy-MM-dd').format(created.date),
                    }),
                  );
                },
                child: Text(l.t('bookings_save')),
              ),
            ],
          );
        });
      },
    );
  }
}
