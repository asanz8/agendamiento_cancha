import 'package:dio/dio.dart';

class WeatherApi {

  static Future<Response<dynamic>> getWeather() async {
    return await Dio().get('https://api.openweathermap.org/data/2.5/onecall?lat=40.714&lon=-74.006&exclude=minutely,hourly,alerts&appid=6088a3cb558b2566bd71c87c982af244');
  }

}