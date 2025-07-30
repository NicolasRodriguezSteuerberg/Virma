import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/data/model/watch_movie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class WatchCommonViewmodel extends ChangeNotifier {
  late String backendUrl;
  late String fileUrl;
  final Duration move_button_seconds = Duration(seconds: 10);

  WatchCommonViewmodel() {
    backendUrl = dotenv.env["BACKEND_URL"] ?? "http://localhost:8080/virma/api";
    fileUrl = dotenv.env["FILE_URL"] ?? "http://localhost:9080";
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

  Future<void> fetchAndInitController(String id);
  void changeToNextEpisode();

  void setLoaded () {
    _isLoaded = true;
  }

  void setLoading(bool value) => _loading = value;
  void setError(bool value) => _error = value;

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
