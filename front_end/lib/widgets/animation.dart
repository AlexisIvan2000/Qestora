import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageAnimation extends StatelessWidget {
  const ImageAnimation({super.key, required this.imageList});

  final List<String> imageList;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 190, 
        autoPlay: true,
        enlargeCenterPage: true,
        autoPlayInterval: const Duration(seconds: 2),
        viewportFraction: 0.8,
      ),
      items: imageList.map((path) {
        return Builder(
          builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                path,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}