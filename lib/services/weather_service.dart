import 'dart:convert';
import 'package:flutter_application_demo/models/weather_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService{

  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String API_KEY;
  
  WeatherService(this.API_KEY);

  Future<Weather> getWeatherByPosition(Position position) async{
    
    Uri url = Uri.parse('$BASE_URL?lat=${position.latitude}&lon=${position.longitude}&appid=$API_KEY&units=metric');

    final response = await http.get(url);

    if(response.statusCode != 200){
      throw Exception('Fallo el carga de clima');
    }

    return Weather.fromJson(jsonDecode(response.body));
  }

  Future<Weather> getWeather(String cityName) async{
    
    final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$API_KEY&units=metric'));

    if(response.statusCode != 200){
      throw Exception('Fallo el carga de clima');
    }

    return Weather.fromJson(jsonDecode(response.body));
  }

  Future<Position> getPosition() async{

    try{

      LocationPermission permission = await Geolocator.checkPermission();

      if(permission == LocationPermission.denied){

        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
      );
  
      return position;

    }catch(e){
      
      throw e;
    }
  }

  Future<String> getCurrentCity() async{

    // verifica los permisos y si no los pide
    try{

      LocationPermission permission = await Geolocator.checkPermission();

      if(permission == LocationPermission.denied){

        permission = await Geolocator.requestPermission();
      }

      // obtenemos la ubicacion
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
      );
  
      String city = await getCityFromCoordinates(position.latitude, position.longitude);

      return city ?? "error";
    }catch(e){
      return "error";
    }

  }


  Future<String> getCityFromCoordinates(double latitude, double longitude) async {
    final url = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);


        if (decodedResponse.containsKey('address')) {
          final address = decodedResponse['address'] as Map<String, dynamic>;


          String? city = address['city'];
          if (city != null) {
            return city;
          }

          city = address['town'] ?? address['village'];
          if (city != null) {
            return city;
          }

          return "Unknown City";
        }
      }

      return "Unknown City";
    } catch (e) {
      print("Error al obtener la localidad: $e");
      return "Unknown City";
    }
  }

}