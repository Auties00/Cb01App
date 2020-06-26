class Film {
  String name;
  String description;
  String tags;
  String thumbnailUrl;
  String streamingUrl;
  String url;

  Film(this.name, this.description, this.tags, this.thumbnailUrl, this.streamingUrl);

  Film.fromJson(Map<String, dynamic> json){
    name = json['name'];
    description = json['description'];
    tags = json['tags'];
    thumbnailUrl = json['thumbnailUrl'];
    streamingUrl = json['streamUrl'];
    url = json['url'];
  }
}

class FilmContainer {
  List<Film> films;

  FilmContainer.fromJson(Map<String, dynamic> json){
    Iterable iterable = json['films'];
    films = iterable.map((e) => Film.fromJson(e)).toList();
  }
}