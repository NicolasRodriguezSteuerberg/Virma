import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:frontend/data/model/watch_episode.dart';
import 'package:frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:frontend/presentation/viewmodels/watch_common_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class WatchSerieViewmodel extends WatchCommonViewmodel {
  WatchSerieViewmodel(AuthProvider auth): super(auth: auth, isSerie: true);

  WatchEpisode? _info;

  WatchEpisode? get info => _info;


  @override
  Future<void> fetchAndInitController(String id) async{
    if (isLoaded) return;
    setLoading(true);
    setError(false);
    // set Loaded para que si falla una vez no siga llamandose
    // si falla una lo mas probable es que falle mas
    setLoaded();
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("$backendUrl/series/episode/$id"),
        headers: {
          "Authorization": "Bearer ${auth.accessToken}"
        }
      );
      if (!(response.statusCode >= 200 && response.statusCode < 300)) throw Exception("La peticion no ha sido exitosa, ${response.statusCode}, ${response.body}");
      final responseBody = jsonDecode(response.body);
      _info = WatchEpisode.fromJson(responseBody);
      setTitle("Capitulo ${_info!.episodeId}");
      VideoPlayerController _controller = VideoPlayerController.networkUrl(
        Uri.parse(_info!.fileUrl)
      );

      await _controller.initialize();

      _controller.addListener(() => notifyListeners());

      if (_info!.watchedSeconds > 0 && _info!.watchedSeconds < _info!.durationSeconds) {
        _controller.seekTo(Duration(seconds: _info!.watchedSeconds));
      }

      startHideTimer();

      setController(_controller);
      setTitle("Captiulo ${_info!.episodeId}");
    } catch (e) {
      print(e);
      setError(true);
    }

    setLoading(false);
    notifyListeners();
  }
  
  @override
  void changeToNextEpisode(BuildContext context) async {
    if (_info!.nextEpisode != null && _info!.nextEpisode!.number != null){
      controller?.pause();
      stopWatchTimer();
      await updateWatchTime();
      context.push("/watch/serie/${_info!.nextEpisode!.number}");
    }
  }

  @override
  Future<void> updateWatchTime() async {
    final request = await http.post(
      Uri.parse("$backendUrl/watch/episode"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${auth.accessToken}'
      },
      body: jsonEncode({
        "serieId": _info!.serieId,
        "episodeId": _info!.episodeId,
        "watchedSeconds": controller!.value.position.inSeconds
      })
    );

    if (request.statusCode!=200) {
      print("error modificando el tiempo visto de la serie: ${request.body}");
    }
  }

  @override
  void onBackButtonPressed(BuildContext context) {
    context.go("/serie/${_info!.serieId}");
  }
  
}