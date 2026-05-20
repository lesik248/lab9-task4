import 'package:bus_booking_pro/services/storage_service.dart';

/// Returns a fresh in-memory [StorageService]. Synchronous because the
/// memory backend does no I/O — safe inside `testWidgets`' fake clock.
StorageService createTestStorage() => StorageService.memory();
