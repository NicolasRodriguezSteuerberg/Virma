import 'package:frontend/data/model/user_state.dart';

class Film {
  FilmInfo film;
  UserState userState;

  Film(this.film, this.userState);

  factory Film.fromJson(Map<String, dynamic> map){
    return Film(
      FilmInfo.fromJson(map["film"]), 
      UserState.fromJson(map["userState"])
    );
  }
}

class FilmInfo {
  int id;
  String title;
  String? description;
  String coverUrl;
  String fileUrl;
  int durationSeconds;

  FilmInfo(this.id, this.title, this.description, this.coverUrl, this.fileUrl, this.durationSeconds);

  factory FilmInfo.fromJson(Map<String, dynamic> map) {
    return FilmInfo(
      map["id"],
      map["title"],
      map["description"],
      map["coverUrl"],
      map["fileUrl"],
      map["durationSeconds"]
    );
  }
}
