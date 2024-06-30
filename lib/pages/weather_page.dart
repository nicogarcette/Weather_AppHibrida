import 'package:flutter/material.dart';
import 'package:flutter_application_demo/models/weather_model.dart';
import 'package:flutter_application_demo/services/weather_service.dart';
import 'package:lottie/lottie.dart';


class WeatherPage extends StatefulWidget{


  const WeatherPage({super.key});


  @override
  State<WeatherPage> createState() => _WeatherPageState();

}


class _WeatherPageState extends State<WeatherPage>{

  final _weatherService = WeatherService('621644266a3d63b4c887f737427fb999');

  Weather? _weather;

  // fetch _weather
  _fetchWeather() async{
   

    try{

      // get city
     String city = await _weatherService.getCurrentCity();

      //String city = "Quilmes";

      // get weather
      if(city.isEmpty){
        throw Exception('Error al obtener la ciudad');
      }
    
      final weather  = await _weatherService.getWeather(city);

      setState(() {
        _weather = weather;
      });

    }
    catch (e) {
      print(e);
    }
  }
  

  // weather animation
String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; 

    switch (mainCondition.toLowerCase()) {
        case 'clouds':
        case 'mist':
        case 'smoke':
        case 'haze':
        case 'dust':
        case 'fog':
        return 'assets/cloud.json';
        case 'rain':
        case 'drizzle':
        case 'shower rain':
            return 'assets/rain.json';
        case 'thunderstorm':
            return 'assets/thunder.json';
        case 'clear':
            return 'assets/sunny.json';
        default:
            return 'assets/sunny.json';
    }
}

  // init state

  @override
  void initState(){
    super.initState();

    _fetchWeather();
  }

  // @override
  // Widget build(BuildContext context){
  //   return Scaffold(
  //     body: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //       Text(_weather?.CityName ?? "Cargando city.."),
  //
  //       // animacion
  //       Lottie.asset(getWeatherAnimation(_weather?.MainCondition)),
  //
  //       Text('${_weather?.Temperature.round()}°C'),
  //
  //
  //     ])
  //
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Clima'),),
      body: ListView( // Cambia Column por ListView
        children: [
          Center(
            child: Text(_weather?.CityName ?? "Cargando city.."),
          ),
          Center(
            child: Lottie.asset(getWeatherAnimation(_weather?.MainCondition)),
          ),
          Center(
            child: Text('${_weather?.Temperature.round()}°C'),
          ),
        ],
      ),
    );
  }
}