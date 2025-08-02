import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/viewmodels/watch_common_viewmodel.dart';

class LeftControlButtons extends StatelessWidget {

  final WatchCommonViewmodel vm;
  const LeftControlButtons({required this.vm, super.key});

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
        if (kIsWeb)...[ Row(
          children: [
            IconButton(
              onPressed: () => vm.setVolume(vm.volume == 0 ? 1.0 : 0.0), 
              icon: Icon(
                vm.volume == 0
                  ? Icons.volume_off
                  : vm.volume < 0.5
                    ? Icons.volume_down
                    : Icons.volume_up,
                color: Colors.white,
              )
            ),
            Slider(
              value: vm.volume, 
              min: 0.0,
              max: 1.0,
              activeColor: Colors.red,
              onChanged: vm.setVolume
            )
          ],
        )]
      ],
    );
  }
}
