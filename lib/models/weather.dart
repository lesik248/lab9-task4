class WeatherPoint {
  final int hourOffset;
  final double tempC;
  const WeatherPoint(this.hourOffset, this.tempC);

  Map<String, dynamic> toJson() => {'h': hourOffset, 't': tempC};
  factory WeatherPoint.fromJson(Map<String, dynamic> j) =>
      WeatherPoint((j['h'] as num).toInt(), (j['t'] as num).toDouble());
}

class Weather {
  final double tempC;
  final int humidity;
  final String description;
  final bool isStub;
  final List<WeatherPoint> forecast;

  const Weather({
    required this.tempC,
    required this.humidity,
    required this.description,
    required this.isStub,
    required this.forecast,
  });

  Map<String, dynamic> toJson() => {
        't': tempC,
        'h': humidity,
        'd': description,
        's': isStub,
        'f': forecast.map((p) => p.toJson()).toList(),
      };

  factory Weather.fromJson(Map<String, dynamic> j) => Weather(
        tempC: (j['t'] as num).toDouble(),
        humidity: (j['h'] as num).toInt(),
        description: j['d'] as String,
        isStub: (j['s'] as bool?) ?? false,
        forecast: ((j['f'] as List?) ?? const [])
            .map((e) => WeatherPoint.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  factory Weather.stub(double seed) {
    final base = (seed.abs() % 25);
    return Weather(
      tempC: base,
      humidity: 60 + (seed.toInt().abs() % 20),
      description: 'clouds (offline)',
      isStub: true,
      forecast: List.generate(
        24,
        (i) => WeatherPoint(i, base + (i % 6) - 3),
      ),
    );
  }
}
