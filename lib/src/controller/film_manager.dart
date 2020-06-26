import 'package:cb01/src/template/film.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FilmManager {
  static final FilmManager _instance = FilmManager._internal();

  FilmContainer newFilms;
  FilmContainer recommendedFilms;

  FilmManager._internal();

  Future<bool> initializeData() async{
    try {
      var newFilmsRequest = await http.get('http://192.168.1.30:8080/new').timeout(Duration(seconds: 5));
      var newFilmsJson = json.decode(utf8.decode(newFilmsRequest.bodyBytes));

      var recommendedFilmsRequest = await http.get('http://192.168.1.30:8080/recommended').timeout(Duration(seconds: 5));
      var recommendedFilmsJson = json.decode(utf8.decode(recommendedFilmsRequest.bodyBytes));

      newFilms = FilmContainer.fromJson(newFilmsJson);
      recommendedFilms = FilmContainer.fromJson(recommendedFilmsJson);
    }on Exception catch(_){
      return false;
    }

    return true;
  }

  Future<FilmContainer> searchFilms(String query) async{
    try {
      var newFilmsRequest = await http.get('http://192.168.1.30:8080/search', headers: {'query' : query});
      var newFilmsJson = json.decode(utf8.decode(newFilmsRequest.bodyBytes));
      return FilmContainer.fromJson(newFilmsJson);
    }on Exception catch(e, s){
      return null;
    }
  }

  Future<String> findStreamingUrl(Film film) async{
    try {
      var newFilmsRequest = await http.get('http://192.168.1.30:8080/stream', headers: {'link' : film.url});
      return utf8.decode(newFilmsRequest.bodyBytes);
    }on Exception catch(e, s){
      return null;
    }
  }

  factory FilmManager() {
    return _instance;
  }
}