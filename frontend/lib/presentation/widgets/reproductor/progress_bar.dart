import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final Function(double) onSeek;

  const ProgressBar({required this.position, required this.duration, required this.onSeek, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Slider(
            value: position.inMilliseconds.clamp(0, duration.inMilliseconds).toDouble(),
            min: 0,
            max: duration.inMilliseconds.toDouble(),
            onChanged: onSeek,
            activeColor: Colors.red,
          ),
        ),
        Text(
          "${_format(position)}/${_format(duration)}",
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  String _format(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
