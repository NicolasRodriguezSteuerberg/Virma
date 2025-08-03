import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/viewmodels/movies_viewmodel.dart';
import 'package:frontend/presentation/widgets/browse/serie_film_card.dart';
import 'package:frontend/presentation/widgets/browse/share_app_bar.dart';
import 'package:provider/provider.dart';

class MoviesPage extends StatefulWidget {

  const MoviesPage({super.key});
  
  @override
  State<StatefulWidget> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // Llamamos en next frame para asegurar que el provider esté disponible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialized) {
        final vm = Provider.of<MoviesViewmodel>(context, listen: false);
        vm.fetchMovies();
        _initialized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ShareAppBar("/movies"),
      body: Consumer<MoviesViewmodel>(builder: (context, vm, __) {
        if (vm.loading) return const Center(child: CircularProgressIndicator());
        return vm.error
          ? Center(child: Text("Error recogiendo las series"))
          : Padding(
            padding: EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: kIsWeb
                  ? 8
                  : 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 9/16,
              ), 
              itemCount: vm.movies.length,
              itemBuilder: (_, i) {
                return SerieFilmCard(
                  id: vm.movies[i].film.id, 
                  title: vm.movies[i].film.title, 
                  imageUrl: vm.movies[i].film.coverUrl, 
                  duration: vm.movies[i].film.durationSeconds, 
                  progress: vm.movies[i].userState.watchedSeconds,
                  isSerie: false,
                );
              }
            ),
          );
      }),
    );
  }
  
}