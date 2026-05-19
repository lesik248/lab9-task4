class Booking {
  final String id;
  final String fromCityId;
  final String toCityId;
  final DateTime date;
  final int seat;

  const Booking({
    required this.id,
    required this.fromCityId,
    required this.toCityId,
    required this.date,
    required this.seat,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'] as String,
        fromCityId: json['fromCityId'] as String,
        toCityId: json['toCityId'] as String,
        date: DateTime.parse(json['date'] as String),
        seat: json['seat'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'fromCityId': fromCityId,
        'toCityId': toCityId,
        'date': date.toIso8601String(),
        'seat': seat,
      };
}
