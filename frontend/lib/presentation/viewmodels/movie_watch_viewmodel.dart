import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/data/model/watch_movie.dart';
import 'package:frontend/presentation/viewmodels/watch_common_viewmodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MovieWatchViewmodel extends WatchCommonViewmodel {

  MovieWatchViewmodel(): super();

  WatchMovie? _info;
  WatchMovie? get movie => _info;

  @override
  Future<void> fetchAndInitController(String id) async {
    if (isLoaded) return; // evitar recarga

    setLoading(true);
    setError(false);
    notifyListeners();

    try {
      final response = await http.get(Uri.parse("$backendUrl/movie/$id"));
      final responseBody = jsonDecode(response.body);
      _info = WatchMovie.fromJson(responseBody);

      if (_info != null) {
        _info!.film.fileUrl = _info!.film.fileUrl.replaceFirst("localhost", "192.168.1.38");

        VideoPlayerController controller = VideoPlayerController.networkUrl(Uri.parse(_info!.film.fileUrl));
        await controller.initialize();

        controller.addListener(() {
          notifyListeners();
        });

        if (_info!.userState != null && _info!.userState!.watchedSeconds > 0) {
          controller.seekTo(Duration(seconds: _info!.userState!.watchedSeconds));
        }
        setController(controller);
        startHideTimer();
      }

      setLoaded();
    } catch (e) {
      print(e);
      setError(true);
    }

    setLoading(false);
    notifyListeners();
  }
  
  @override
  void changeToNextEpisode(BuildContext context) {}

}