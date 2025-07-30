class UserState {
  bool? liked;
  int watchedSeconds;

  UserState(this.liked, this.watchedSeconds);

  factory UserState.fromJson(Map<String, dynamic> map) {
    return UserState(
      map["liked"],
      map["watchedSeconds"]
    );
  }
}