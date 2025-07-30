import 'package:frontend/data/model/film.dart';
import 'package:frontend/data/model/user_state.dart';

class WatchMovie {
  FilmInfo film;
  UserState? userState;
  WatchMovie(this.film, this.userState);

  factory WatchMovie.fromJson(Map<String, dynamic> map) {
    return WatchMovie(
      FilmInfo.fromJson(map["film"]),
      map["userState"] == null
        ? null
        : UserState.fromJson(map["userState"])
    );
  }
}