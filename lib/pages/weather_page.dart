import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_demo/models/weather_model.dart';
import 'package:flutter_application_demo/services/weather_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_application_demo/widgets/carousel.dart';
import 'package:image_picker/image_picker.dart';

class WeatherPage extends StatefulWidget{

  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();

}

class _WeatherPageState extends State<WeatherPage>{

  final _weatherService = WeatherService('621644266a3d63b4c887f737427fb999');

  Weather? _weather;
  List<Widget> _carouselItems = [];
  List<XFile> _imageFiles = [];

  _fetchWeather() async{
   
    try{

     Position position = await _weatherService.getPosition();
    
      final weather  = await _weatherService.getWeatherByPosition(position);

      setState(() {
        _weather = weather;
        _prepareCarouselItems();
      });

    }
    catch (e) {
      print(e);
    }
  }
  

 
String getWeatherAnimation(String? mainCondition) {
  
  if (mainCondition == null) return 'assets/loader.json'; 

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
 void _prepareCarouselItems() {
    _carouselItems = [
      Container(
        child:Image.asset('assets/clima.jpg'),
      )
    ];
  }

   void _updateCarouselItems() {
    _carouselItems.clear();
    _imageFiles.forEach((imageFile) {
      _carouselItems.add(

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: FileImage(File(imageFile.path)),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    });
  }

   Future<void> tomarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
        setState(() {
        _imageFiles.add(pickedFile);
        _updateCarouselItems();
      });
    }
  }

  @override
  void initState(){
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Clima',
          style: TextStyle(
            fontWeight: FontWeight.w500
          ),),
        
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 40.0),
        children: [
          Center(
            child: Text(
              _weather?.CityName ?? "Cargando ciudad..",
              style: TextStyle( 
                fontWeight: FontWeight.bold,
                fontSize: 24.0
                ),
              ),
          ),
          Center(
            child: Lottie.asset(getWeatherAnimation(_weather?.MainCondition)),
          ),
          Center(
            child: Text('${_weather?.Temperature.round()}°C'),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0,top: 30.0, bottom: 15.0),
            child: Text(  
              "Foto de tu clima",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23.0,
              ),
            ),
          ),
          Carousel(items: _carouselItems),
          SizedBox(height: 30.0),
          Center(
          child: OutlinedButton(
            onPressed: tomarFoto,
            child: Text('Tomar foto'),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        ],
      ),
    );
  }
}