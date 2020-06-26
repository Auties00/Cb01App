import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cb01/src/controller/film_manager.dart';
import 'package:flutter/material.dart';

class SlidingPageView extends StatefulWidget {
  SlidingPageView({Key key}) : super(key: key);

  @override
  _SlidingPageViewState createState() => _SlidingPageViewState();
}

class _SlidingPageViewState extends State<SlidingPageView> {
  final FilmManager _manager = FilmManager();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 175.0,
      width: double.maxFinite,
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.8
        ),
        items: _manager.recommendedFilms.films.map((item) => Container(
          child: Container(
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: Image.network(item.thumbnailUrl, fit: BoxFit.cover, width: 1500.0)
            ),
          ),
        )).toList()
      ),
    );
  }
}