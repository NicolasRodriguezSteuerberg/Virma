class WatchEpisode {
  int serieId;
  int episodeId;
  int number;
  int durationSeconds;
  String fileUrl;
  int watchedSeconds;
  NextEpisode? nextEpisode;

  WatchEpisode(
    this.serieId, this.episodeId, this.number, 
    this.durationSeconds, this.fileUrl, this.watchedSeconds,
    this.nextEpisode
  );

  factory WatchEpisode.fromJson(Map<String, dynamic> jsonData) {
    return WatchEpisode(
      jsonData["serieId"], 
      jsonData["episodeId"],
      jsonData["number"],
      jsonData["durationSeconds"],
      jsonData["fileUrl"],
      jsonData["watchedSeconds"],
      jsonData["nextEpisode"] != null
        ? NextEpisode.fromJson(jsonData["nextEpisode"])
        : null
    );
  }
}

class NextEpisode {
  int? id;
  int? number;

  NextEpisode(this.id, this.number);

  factory NextEpisode.fromJson(Map<String, dynamic> nextEpisode) {
    return NextEpisode(
      nextEpisode["id"],
      nextEpisode["number"]
    );
  }
}