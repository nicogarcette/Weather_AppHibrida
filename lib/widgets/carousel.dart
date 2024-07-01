import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class Carousel extends StatelessWidget {

  final List<Widget> items;

  const Carousel({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    
    return CarouselSlider(
      
      options: CarouselOptions(height: 200.0),
      
      items: items.map((item) {
      
        return Builder(
      
          builder: (BuildContext context) {
      
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: item,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50)
              ),
            );
          },
        );
      
      }).toList(),
    
    );
  }
}