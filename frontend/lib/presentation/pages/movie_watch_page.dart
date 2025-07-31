import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/presentation/viewmodels/movie_watch_viewmodel.dart';
import 'package:frontend/presentation/widgets/reproductor/video_controls_overlay.dart';
import 'package:frontend/presentation/widgets/reproductor/video_player_container.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class MovieWatchPage extends StatelessWidget {
  final String filmId;

  const MovieWatchPage({required this.filmId, super.key});
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MovieWatchViewmodel>();

    // Lanzar carga de película al inicializar widget (solo una vez)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!vm.isLoaded && !vm.loading) {
        vm.fetchAndInitController(filmId);
      }
    });

    if (vm.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (vm.error) {
      return const Scaffold(
        body: Center(child: Text("Hubo un error intentando recoger la información de la película")),
      );
    }

    if (vm.controller == null || vm.controller!.value.hasError) {
      return const Scaffold(
        body: Center(child: Text("Error cargando el video")),
      );
    }

    return Scaffold(
      body: Listener(
        onPointerHover: (_) => vm.onUserEvent(),
        onPointerMove: (_) => vm.onUserEvent(),
        onPointerDown: (_) => vm.onUserEvent(),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            VideoPlayerContainer(controller: vm.controller!),
            if (vm.showControls) VideoControlsOverlay(vm: vm)
          ],
        ),
      )
    );
  }
  /*
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MovieWatchViewmodel>();

    // Lanzar carga de película al inicializar widget (solo una vez)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!vm.isLoaded) {
        vm.fetchMovieAndInit(filmId);
      }
    });

    if (vm.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (vm.error) {
      return const Scaffold(
        body: Center(child: Text("Hubo un error intentando recoger la información de la película")),
      );
    }

    if (vm.controller == null || vm.controller!.value.hasError) {
      return const Scaffold(
        body: Center(child: Text("Error cargando el video")),
      );
    }

    return Scaffold(
      body: Listener(
        onPointerHover: (_) => vm.onUserEvent(),
        onPointerMove: (_) => vm.onUserEvent(),
        onPointerDown: (_) => vm,
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            VideoPlayerContainer(controller: vm.controller!),
            if (vm.showControls)
              buildControls(context, vm),
          ],
        ),
      ),
    );
  }

  Widget buildControls(BuildContext context, MovieWatchViewmodel vm) {
    final position = vm.controller!.value.position;
    final duration = vm.controller!.value.duration;

    return Container(
      color: Colors.black45,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: position.inMilliseconds.clamp(0, duration.inMilliseconds).toDouble(),
                  min: 0,
                  max: duration.inMilliseconds.toDouble(),
                  onChangeStart: (_) => vm.onUserEvent(),
                  onChanged: (value) {
                    vm.controller?.seekTo(Duration(milliseconds: value.toInt()));
                  },
                  onChangeEnd: (_) => vm.onUserEvent(),
                  activeColor: Colors.red,
                ),
              ),
              /*Expanded(child: VideoProgressIndicator(
                vm.controller!, 
                allowScrubbing: true,
                colors:  VideoProgressColors(
                  playedColor: Colors.red,
                  bufferedColor: Colors.green,
                  backgroundColor: Colors.black26,
                )
              )),*/
              Text(
                "${vm.formatDuration(position)}/${vm.formatDuration(duration)}",
                style: const TextStyle(color: Colors.white),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => vm.onPlayPauseButtonPressed(),
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
                  // agregar el slider de sonido
                  IconButton(
                    onPressed: onPressed, 
                    icon: icon
                  )
                ],
              ),
              IconButton(
                onPressed: () {
                  // Aquí puedes implementar fullscreen si quieres
                },
                icon: const Icon(Icons.fullscreen, color: Colors.white),
              )
            ],
          )
        ],
      ),
    );
  }
  */
}
