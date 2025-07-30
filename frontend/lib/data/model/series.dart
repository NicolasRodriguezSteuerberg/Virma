class Series {
  int id;
  String title;
  String coverUrl;

  Series(this.id, this.title, this.coverUrl);

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      json["id"],
      json["title"],
      json["coverUrl"]
    );
  }
}