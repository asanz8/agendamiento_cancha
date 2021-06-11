import 'package:agendamiento_cancha/src/remote/weather_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test('Consultar Weather Api', () async {
    final response = await WeatherApi.getWeather();

    expect(response.data['timezone'], equals('America/New_York'));
  });
}