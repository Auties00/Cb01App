import 'package:cb01/src/constant/color.dart';
import 'package:cb01/src/controller/film_manager.dart';
import 'package:cb01/src/delegate/search_delegate.dart';
import 'package:cb01/src/widget/film_app_bar.dart';
import 'package:cb01/src/widget/film_list_view.dart';
import 'package:cb01/src/widget/sliding_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  final FilmManager _manager = FilmManager();
  var _future;

  @override
  void initState() {
    super.initState();
    _future = _manager.initializeData();
  }

  Future<void> _showSearch() async {
    await showSearch(
      context: context,
      delegate: SearchBarDelegate(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BACKGROUND,
        body: SafeArea(
          child: FutureBuilder<bool>(
            future: _future,
            builder: (BuildContext context, AsyncSnapshot<bool> data) {
              if (!data.hasData) {
                return Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),
                    )
                );
              }

              var result = data.data;
              return Column(
                children: [
                  FilmAppBar(
                    onTap: _showSearch,
                  ),

                  SizedBox(height: 25.0),

                  SlidingPageView(),

                  SizedBox(height: 25.0),

                  FilmListView(
                      title: 'New',
                      films: _manager.newFilms.films,
                      condition: () => result
                  ),

                  SizedBox(height: 25.0),

                  FilmListView(
                      title: 'Popular',
                      films: _manager.recommendedFilms.films,
                      condition: () => result
                  ),
                ],
              );
            },
          ),
        )
    );
  }
}
