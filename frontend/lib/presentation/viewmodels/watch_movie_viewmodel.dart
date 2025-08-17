import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/data/model/watch_movie.dart';
import 'package:frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:frontend/presentation/viewmodels/watch_common_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';

class WatchMovieViewmodel extends WatchCommonViewmodel {

  WatchMovieViewmodel(AuthProvider auth): super(auth: auth, isSerie: false);

  WatchMovie? _info;
  WatchMovie? get movie => _info;

  @override
  Future<void> fetchAndInitController(String id) async {
    if (isLoaded) return; // evitar recarga

    setLoading(true);
    setError(false);
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("$backendUrl/movie/$id"), 
        headers: {
          'Content-type': 'application/json',
          "Authorization": "Bearer ${auth.accessToken}"
        }
      );
      final responseBody = jsonDecode(response.body);
      _info = WatchMovie.fromJson(responseBody);

      if (_info != null) {
        _info!.film.fileUrl = _info!.film.fileUrl.replaceFirst("localhost", "192.168.1.38");

        VideoPlayerController controller = VideoPlayerController.networkUrl(Uri.parse(_info!.film.fileUrl));
        await controller.initialize();

        controller.addListener(() {
          notifyListeners();
        });

        if (_info!.userState != null && _info!.userState!.watchedSeconds != null && _info!.userState!.watchedSeconds! > 0) {
          controller.seekTo(Duration(seconds: _info!.userState!.watchedSeconds!));
        }
        setController(controller);
        startHideTimer();
        setTitle(_info!.film.title);
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
  
  @override
  Future<void> updateWatchTime() async {
    final request = await http.post(
      Uri.parse("$backendUrl/watch/movie"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${auth.accessToken}'
      },
      body: jsonEncode({
        "filmId": _info!.film.id,
        "watchedSeconds": controller!.value.position.inSeconds
      })
    );

    if (request.statusCode!=200) {
      print("error modificando el tiempo visto de la serie: ${request.body}");
    }
  }

  @override
  void onBackButtonPressed(BuildContext context) {
    context.go("/movies");
  }

}