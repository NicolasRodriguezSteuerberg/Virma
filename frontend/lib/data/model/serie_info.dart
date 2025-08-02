class SerieInfo {
  int id;
  String title;
  String description;
  String coverUrl;
  List<SeasonInfo> seasons;

  SerieInfo(this.id, this.title, this.description, this.coverUrl, this.seasons);

  factory SerieInfo.fromJson(Map<String, dynamic> jsonData) {
    List<SeasonInfo> seasons = [];

    List<dynamic>? seasonInfo = jsonData["seasonList"];
    if (seasonInfo != null) {
      for (var element in seasonInfo) {
        seasons.add(SeasonInfo.fromJson(element));
      }
    } 
    return SerieInfo(
      jsonData["serieInfo"]["id"],
      jsonData["serieInfo"]["title"],
      jsonData["serieInfo"]["description"],
      jsonData["serieInfo"]["coverUrl"],
      seasons
    );
  }
}

class SeasonInfo {
  int id;
  int number;
  List<EpisodeInfo> episodes;

  SeasonInfo(this.id, this.number, this.episodes);

  factory SeasonInfo.fromJson(Map<String, dynamic> jsonData) {
    print("Season: $jsonData");
    List<EpisodeInfo> episodes = [];

    List<dynamic>? seasonInfo = jsonData["episodeList"];
    if (seasonInfo != null) {
      for (var element in seasonInfo) {
        episodes.add(EpisodeInfo.fromJson(element));
      }
    } 

    return SeasonInfo(
      jsonData["id"],
      jsonData["number"],
      episodes
    );
  }
} 

class EpisodeInfo {
  int id;
  int number;
  String? coverUrl;
  int durationSeconds;
  int? watchedSeconds;

  EpisodeInfo(this.id, this.number, this.coverUrl, this.durationSeconds, this.watchedSeconds);

  factory EpisodeInfo.fromJson(Map<String, dynamic> jsonData) {
    print("Episode: $jsonData");
    return EpisodeInfo(
      jsonData["id"],
      jsonData["number"],
      jsonData["coverUrl"],
      jsonData["durationSeconds"],
      jsonData["userWatchedSeconds"]
    );
  }
}