import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // API key
  final _weatherService = WeatherService('c8874453b49844ca38edf0b5992dfb9d');
  Weather? _weather;

  // Fetch weather
  Future<void> _fetchWeather() async {
    // Get current city
    String cityName = await _weatherService.getCurrentCity();

    // Get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  // Weather animations
  String getWeatherAnimations(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; // default to sunny
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'fog':
      case 'dust':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // Init state
  @override
  void initState() {
    super.initState();
    // Fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF210cae),
              Color(0xFF4dc9e6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                color: Colors.white,
                size: 30,
              ),
              // City name
              Text(
                _weather?.cityName ?? "loading city..",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'SmoochSans',
                ),
              ),
              SizedBox(height: 40),
              // Animation
              Lottie.asset(getWeatherAnimations(_weather?.mainCondition)),
              SizedBox(height: 40),
              // Temperature
              Text(
                '${_weather?.temperature.round()} °C',
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'SmoochSans',
                  color: Colors.white,
                ),
              ),
              // Weather condition
              Text(
                '${_weather?.mainCondition}',
                style: TextStyle(
                  fontSize: 36,
                  fontFamily: 'SmoochSans',
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}