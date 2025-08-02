import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/viewmodels/watch_common_viewmodel.dart';

class RightControlsButtons extends StatelessWidget {
  final WatchCommonViewmodel vm;

  const RightControlsButtons({required this.vm});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (vm.isSerie) IconButton(
          onPressed: () => vm.changeToNextEpisode(context),
          icon: Icon(
            Icons.skip_next,
            color: Colors.white,
          )
        ),
        if (kIsWeb) IconButton(
          onPressed: () => vm.setFullScreen(),
          icon: Icon(
            Icons.fullscreen,
            color: Colors.white,
          )
        )
      ],
    );
  }

}