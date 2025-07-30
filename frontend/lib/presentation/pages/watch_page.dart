import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class WatchPage extends StatefulWidget{
  const WatchPage({super.key});

  @override
  State<StatefulWidget> createState() => _VideoState();

}

class _VideoState extends State<WatchPage>{
  late VideoPlayerController _videoPlayerController;
  bool _showControls = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse("http://192.168.1.38:9080/virma/series/rwby/02/004/index.m3u8")
    )..initialize()
      .then((_) => setState(() {
        onUserEvent();
      }))
      .catchError((e) => print(e));
    
    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.isInitialized) {
        setState(() {});
      }
    });
    
  }

  @override
  void dispose() {
    _videoPlayerController.removeListener(() {});
    _videoPlayerController.dispose();
    super.dispose();
  }

  void onUserEvent() {
    print("hola, $_showControls");
    if (_hideTimer != null) {
      _hideTimer!.cancel();
    }
    if (!_showControls) {
      setState(() {
        _showControls = true;
      });
    }
    _hideTimer = Timer(
      Duration(seconds: 3), 
      () => setState(() => _showControls = false)
    );
  }

   String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    // ToDo app bar para cuando se muestren los controles, para poder ir para atrás
    return Scaffold(
        body: Center(
          child: _videoPlayerController.value.isInitialized
            ? Listener(
              onPointerHover: (_) => onUserEvent(),
              onPointerMove: (_) => onUserEvent(),
              onPointerDown: (_) => onUserEvent(),
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  ),
                  if (_showControls) buildControls(context)
                ],
              )
            ): CircularProgressIndicator()
        ),
       
      );
  }

  Widget buildControls(BuildContext context) {
    final position = _videoPlayerController.value.position;
    final duration = _videoPlayerController.value.duration;

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
                  onChangeStart: (_) => onUserEvent(),
                  onChanged: (value) {
                    _videoPlayerController.seekTo(Duration(milliseconds: value.toInt()));
                  },
                  onChangeEnd: (_) => onUserEvent(),
                ),
              ),
              Text(
                "${_formatDuration(position)}/${_formatDuration(duration)}",
                style: TextStyle(
                  color: Colors.white
                ),
              )
            ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => _videoPlayerController.value.isPlaying
                      ? _videoPlayerController.pause()
                      : _videoPlayerController.play()
                    ,
                    icon: Icon(
                      _videoPlayerController.value.isPlaying
                        ?Icons.pause: 
                        Icons.play_arrow,
                      color: Colors.white,
                    )
                  ),
                  IconButton(
                    onPressed: () => _videoPlayerController.seekTo(position - Duration(seconds: 10)),
                    icon: Icon(
                      Icons.replay_10,
                      color: Colors.white,
                    )
                  ),
                  IconButton(
                    onPressed: () => _videoPlayerController.seekTo(position + Duration(seconds: 10)),
                    icon: Icon(
                      Icons.forward_10,
                      color: Colors.white,
                    )
                  )
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => {},
                    icon: Icon(
                      Icons.fullscreen,
                      color: Colors.white,
                    )
                  )
                ],
              )
            ],
          )
        ]
      )
    );
  }
}