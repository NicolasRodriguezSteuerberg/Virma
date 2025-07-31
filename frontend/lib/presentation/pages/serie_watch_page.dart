import 'package:flutter/material.dart';
import 'package:frontend/presentation/viewmodels/watch_serie_viewmodel.dart';
import 'package:frontend/presentation/widgets/reproductor/video_controls_overlay.dart';
import 'package:frontend/presentation/widgets/reproductor/video_player_container.dart';
import 'package:provider/provider.dart';

class SerieWatchPage extends StatelessWidget {
  final String episodeId;

  const SerieWatchPage({required this.episodeId, super.key});
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WatchSerieViewmodel>();

    // Lanzar carga de película al inicializar widget (solo una vez)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!vm.isLoaded && !vm.loading) {
        vm.fetchAndInitController(episodeId);
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
}
