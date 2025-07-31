import 'package:flutter/material.dart';
import 'package:frontend/presentation/viewmodels/watch_common_viewmodel.dart';

class VolumeControl extends StatelessWidget {
  final WatchCommonViewmodel vm;
  const VolumeControl({required this.vm, super.key});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => vm.setShowVolumeSlider(true),
      onExit: (_) => vm.setShowVolumeSlider(false),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: vm.showVolumeSlider ? 1.0 : 0.0,
            child: Visibility(
              visible: vm.showVolumeSlider,
              child: Container(
                height: 125,
                width: 40,
                margin: const EdgeInsets.only(bottom: 40),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RotatedBox(
                  quarterTurns: -1,
                  child: Slider(
                    value: vm.volume,
                    onChanged: vm.setVolume,
                    min: 0.0,
                    max: 1.0,
                    activeColor: Colors.red,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => vm.setVolume(vm.volume == 0 ? 1.0 : 0.0),
            icon: Icon(
              vm.volume == 0
                  ? Icons.volume_off
                  : vm.volume < 0.5
                      ? Icons.volume_down
                      : Icons.volume_up,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
