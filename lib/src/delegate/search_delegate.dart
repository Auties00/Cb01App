import 'package:cb01/src/constant/color.dart';
import 'package:cb01/src/controller/film_manager.dart';
import 'package:cb01/src/page/player_page.dart';
import 'package:cb01/src/template/film.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchBarDelegate extends SearchDelegate {
  var _manager = FilmManager();

  @override
  List<Widget> buildActions(BuildContext context) {
    return query.isNotEmpty ? [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          this.query = "";
        },
      )
    ] : [
      IconButton(
        icon: Icon(Icons.keyboard_voice),
        onPressed: () {

        },
      )
    ];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
        primaryColor: BACKGROUND,
        inputDecorationTheme: theme.inputDecorationTheme.copyWith(hintStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.white), labelStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.white)),
        primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.white),
        primaryColorBrightness: Brightness.dark,
        primaryTextTheme: theme.primaryTextTheme,
        textTheme: theme.textTheme.copyWith(title: theme.textTheme.title.copyWith(color: Colors.white)));
  }

  @override
  String get searchFieldLabel => 'Search a film';


  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Text('Please enter a valid film'),
      );
    }

    _addSearchHistory();

    var future = _manager.searchFilms(query);
    return Container(
      color: BACKGROUND,
      child: FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<FilmContainer> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == null) {
              return Center(
                child: Text("Please check your internet connection!"),
              );
            }

            var films = snapshot.data.films;
            return NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (e) {
                e.disallowGlow();
                return false;
              },
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75
                ),
                scrollDirection: Axis.vertical,
                itemCount: films.length,
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0),
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlayerPage(film: films[index]))),
                      child: Image.network(films[index].thumbnailUrl, fit: BoxFit.fill),
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(ELEVATED),
              ),
            );
          }
        },
      ),
    );
  }

  _addSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var history = (prefs.getStringList('search_history') ?? List());
    history.add(query);
    await prefs.setStringList('search_history', history);
  }


  Future<List<String>> _searchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs
        .getStringList('search_history')
        .reversed
        .toSet()
        .toList() ?? List<String>();
  }

  Future _removeSearchHistoryEntry(String entry) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var history = (prefs.getStringList('search_history') ?? List());
    history.remove(entry);
    await prefs.setStringList('search_history', history);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var future = _searchHistory();
    return Container(
      color: BACKGROUND,
      child: FutureBuilder(
          future: future,
          builder: (context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.hasData) {
              List<String> suggestions = snapshot.data;
              return NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (e) {
                  e.disallowGlow();
                  return false;
                },
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        this.query = suggestions[index];
                        showResults(context);
                      },

                      onLongPress: () {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return PlatformAlertDialog(
                              title: Text(suggestions[index]),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('Remove from search history?')
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                PlatformDialogAction(
                                  child: Text('CANCEL'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                PlatformDialogAction(
                                  child: Text('REMOVE'),
                                  actionType: ActionType.Preferred,
                                  onPressed: () {
                                    _removeSearchHistoryEntry(suggestions[index])
                                        .then((value) =>
                                        Navigator.of(context).pop())
                                        .then((value) => buildSuggestions(context));
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },

                      child: ListTile(
                        leading: IconButton(
                          onPressed: () {
                            this.query = suggestions[index];
                            showResults(context);
                          },

                          icon: Icon(Icons.history),
                        ),

                        title: Text(suggestions[index]),
                      ),
                    );
                  },
                  itemCount: suggestions.length,
                ),
              );
            }

            return Container(

            );
          }
      ),
    );
  }
}

