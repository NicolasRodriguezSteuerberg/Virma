import 'package:flutter/material.dart';
import 'package:frontend/presentation/viewmodels/movie_watch_viewmodel.dart';

class PlaybackButtons extends StatelessWidget {

  final MovieWatchViewmodel vm;
  const PlaybackButtons({required this.vm, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: vm.onPlayPauseButtonPressed,
          icon: Icon(
            vm.controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () => vm.onMove10IconPressed(false),
          icon: const Icon(Icons.replay_10, color: Colors.white),
        ),
        IconButton(
          onPressed: () => vm.onMove10IconPressed(true),
          icon: const Icon(Icons.forward_10, color: Colors.white),
        ),
      ],
    );
  }
}
