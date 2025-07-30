import 'package:flutter/material.dart';
import 'package:frontend/presentation/viewmodels/movie_watch_viewmodel.dart';
import 'package:frontend/presentation/widgets/reproductor/playback_buttons.dart';
import 'package:frontend/presentation/widgets/reproductor/progress_bar.dart';
import 'package:frontend/presentation/widgets/reproductor/volume_control.dart';

class VideoControlsOverlay extends StatelessWidget{
  final MovieWatchViewmodel vm;

  const VideoControlsOverlay({required this.vm, super.key});

  @override
  Widget build(BuildContext context) {
    final position = vm.controller!.value.position;
    final duration = vm.controller!.value.duration;

    return Container(
      color: Colors.black45,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProgressBar(position: position, duration: duration, onSeek: (ms) {
            vm.controller?.seekTo(Duration(milliseconds: ms.toInt()));
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PlaybackButtons(vm: vm),
              VolumeControl(vm: vm),
              // ToDo manejar el boton de full screen
              // IconButton(onPressed: onPressed, icon: icon)
            ],
          )
        ]
      )
    );
  }
}