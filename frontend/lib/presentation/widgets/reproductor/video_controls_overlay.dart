import 'package:flutter/material.dart';
import 'package:frontend/presentation/viewmodels/watch_common_viewmodel.dart';
import 'package:frontend/presentation/widgets/reproductor/left_controls_buttons.dart';
import 'package:frontend/presentation/widgets/reproductor/progress_bar.dart';
import 'package:frontend/presentation/widgets/reproductor/right_controls_buttons.dart';

class VideoControlsOverlay extends StatelessWidget{
  final WatchCommonViewmodel vm;

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
              LeftControlButtons(vm: vm),
              Text(
                vm.title??"",
                style: TextStyle(
                  fontSize: 22
                ),
              ),
              RightControlsButtons(vm: vm)
            ],
          )
        ]
      )
    );
  }
}