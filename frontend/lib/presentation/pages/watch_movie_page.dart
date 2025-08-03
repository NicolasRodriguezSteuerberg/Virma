import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/presentation/viewmodels/watch_movie_viewmodel.dart';
import 'package:frontend/presentation/widgets/reproductor/back_controls.dart';
import 'package:frontend/presentation/widgets/reproductor/video_controls_overlay.dart';
import 'package:frontend/presentation/widgets/reproductor/video_player_container.dart';
import 'package:provider/provider.dart';

class WatchMoviePage extends StatefulWidget {
  final String filmId;

  const WatchMoviePage({required this.filmId, super.key});

  @override
  State<StatefulWidget> createState() => _WatchMovieState();

}

class _WatchMovieState extends State<WatchMoviePage> {

  @override
  void initState() {
    super.initState();

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  @override
  void dispose() {
    // Al salir de esta página fijamos la orientación a vertical para el resto de la app
    if (!kIsWeb){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WatchMovieViewmodel>();

    // Lanzar carga de película al inicializar widget (solo una vez)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!vm.isLoaded && !vm.loading) {
        vm.fetchAndInitController(widget.filmId);
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
            if (vm.showControls) VideoControlsOverlay(vm: vm),
            if (vm.showControls) Positioned(
              top: 0, 
              left: 0,
              child: BackControls(
                vm: vm,
              )
            ),
          ],
        ),
      )
    );
  }
}
