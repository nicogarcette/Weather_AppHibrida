import 'dart:convert';

import 'package:flutter_application_demo/models/weather_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService{

  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String API_KEY;
  


  WeatherService(this.API_KEY);



  Future<Weather> getWeather(String cityName) async{
    
    final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$API_KEY&units=metric'));

    if(response.statusCode != 200){
      throw Exception('Fallo el carga de clima');
    }

    print(jsonDecode(response.body));

    return Weather.fromJson(jsonDecode(response.body));
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
  
      //print("Position-> latitude:"+ position.latitude.toString());
      //print("Position-> longitude:"+ position.longitude.toString());

      // convertimos la locacion en un a lista
      //List<Placemark> placemark = await placemarkFromCoordinates(position.latitude!,position.longitude!);

      // extraemos la ciudad del primer elemento

      String city = await getCityFromCoordinates(position.latitude, position.longitude);

      // if (placemark != null && placemark.isNotEmpty) {
      //
      //   print(placemark);
      //   String? city = placemark[0].locality;
      //   return city ?? "Unknown City";
      // } else {
      //   return "Unknown City";
      // }

      //String? city = placemark[0].locality;

      return city ?? "error";
    }catch(e){
      //print("Error al obtener la ubicación: $e");
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