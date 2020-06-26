import 'package:cb01/src/page/player_page.dart';
import 'package:cb01/src/template/film.dart';
import 'package:flutter/material.dart';

typedef bool BoolFunction();

class FilmListView extends StatelessWidget {
  final String title;
  final List<Film> films;
  final BoolFunction condition;
  FilmListView({
    @required this.title,
    @required this.films,
    @required this.condition
  });

  @override
  Widget build(BuildContext context) {
    var assertOpt = condition();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(assertOpt) Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
              title,
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white
              )
          ),
        ),

        SizedBox(height: 10.0),

        if(assertOpt) Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: SizedBox(
            height: 175.0,
            child: ListView.separated(
                separatorBuilder: (BuildContext buildContext, int index) =>SizedBox(
                  width: 15.0,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: films.length,
                itemBuilder: (BuildContext context, int index) => Column(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlayerPage(film: films[index]))),
                      child: Container(
                        width: 125.0,
                        height: 175.0,
                        child: Image.network(films[index].thumbnailUrl, fit: BoxFit.cover),
                      ),
                    )
                  ],
                )
            ),
          ),
        )
      ],
    );
  }
}
