import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../models/weather_model.dart';


class WeatherService {
  static const baseUrl = 'http://api.openweathermap.org/data/2.5/weather';
  final String apikey;

  WeatherService(this.apikey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
    .get(Uri.parse('$baseUrl?q=$cityName&appid=$apikey&units=metric'));

  if (response.statusCode == 200){
    return Weather.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load weather data');
  }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high));

    // fetch the current location
    // convert the location into a list of placemark objects
    List<Placemark> placemarks =
    await placemarkFromCoordinates (position.latitude, position.longitude);
    String? city = placemarks[0].locality;
    return city ?? "";
    // extract the city name from the first placemark
  }
}