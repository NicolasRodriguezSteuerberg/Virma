import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/data/model/watch_movie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MovieWatchViewmodel extends ChangeNotifier {
  late String backendUrl;
  final Duration move_button_seconds = Duration(seconds: 10);

  MovieWatchViewmodel() {
    backendUrl = dotenv.env["BACKEND_URL"] ?? "http://localhost:8080/virma/api";
  }

  bool _loading = false;
  bool _error = false;
  bool _isLoaded = false;
  VideoPlayerController? _controller;
  bool _showControls = true;
  bool _showVolumeSlider = false;
  Timer? _hideTimer;

  bool get loading => _loading;
  bool get error => _error;
  bool get isLoaded => _isLoaded;
  VideoPlayerController? get controller => _controller;
  bool get showControls => _showControls;
  double get volume => _controller == null ? 1.0 : _controller!.value.volume;
  bool get showVolumeSlider => _showVolumeSlider;

  WatchMovie? _info;
  WatchMovie? get movie => _info;

  Future<void> fetchMovieAndInit(String filmId) async {
    if (_isLoaded) return; // evitar recarga

    _loading = true;
    _error = false;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse("$backendUrl/movie/$filmId"));
      final responseBody = jsonDecode(response.body);
      _info = WatchMovie.fromJson(responseBody);

      if (_info != null) {
        _info!.film.fileUrl = _info!.film.fileUrl.replaceFirst("localhost", "192.168.1.38");

        _controller = VideoPlayerController.networkUrl(Uri.parse(_info!.film.fileUrl));
        await _controller!.initialize();

        _controller!.addListener(() {
          notifyListeners();
        });

        if (_info!.userState != null && _info!.userState!.watchedSeconds > 0) {
          _controller!.seekTo(Duration(seconds: _info!.userState!.watchedSeconds));
        }

        _startHideTimer();
      }

      _isLoaded = true;
    } catch (e) {
      _error = true;
      print(e);
    }

    _loading = false;
    notifyListeners();
  }

  void onUserEvent() {
    _hideTimer?.cancel();

    if (!_showControls) {
      _showControls = true;
      notifyListeners();
    }

    _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 3), () {
      _showControls = false;
      notifyListeners();
    });
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void onMove10IconPressed (bool forward) {
    Duration position = _controller!.value.position + (forward ? move_button_seconds : -move_button_seconds);
    _controller?.seekTo(
      position <= Duration.zero 
        ? Duration.zero 
        : position > _controller!.value.duration
          ? _controller!.value.duration
          : position
    );

    onUserEvent();
  }

  void onPlayPauseButtonPressed() {
    if (_controller != null && _controller!.value.isInitialized){
      _controller!.value.isPlaying
        ? _controller!.pause()
        : _controller!.play();
        onUserEvent();
    }
  }

  void setShowVolumeSlider(bool show) {
    _showVolumeSlider = show;
    onUserEvent();
  }

  void setVolume(double volume) {
    _controller!.setVolume(volume);
    onUserEvent();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }
}
