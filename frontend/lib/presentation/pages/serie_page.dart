import 'package:flutter/material.dart';
import 'package:frontend/presentation/viewmodels/serie_viewmodel.dart';
import 'package:frontend/presentation/widgets/browse/serie_episode_widget.dart';
import 'package:provider/provider.dart';

class SeriePage extends StatefulWidget{


  @override
  State<StatefulWidget> createState() => _SeriePageState();
  
}

class _SeriePageState extends State<SeriePage> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialized) {
        final vm = Provider.of<SerieViewmodel>(context, listen: false);
        vm.fetchSerie();
        _initialized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SerieViewmodel>(
        builder: (context, vm, __) {
          if (vm.loading) return const Center(child: CircularProgressIndicator(),);
          if (vm.error) return const Center(child: Text("Error recogiendo la informacion de la serie"),);
          return Column(
            children: [
              Text("aa"),
              Expanded(child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                scrollDirection: Axis.vertical,
                itemCount: vm.serie!.seasons.length,
                itemBuilder: (_, index) => ExpansionTile(
                  title: Text("Temporada ${vm.serie!.seasons[index].number}"),
                  children: vm.serie!.seasons[index].episodes.map((episode) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: SerieEpisodeWidget(
                            episodeId: episode.id, 
                            number: episode.number, 
                            coverUrl: episode.coverUrl??vm.serie!.coverUrl, 
                            duration: episode.durationSeconds, 
                            progress: episode.watchedSeconds
                          ),
                        )
                      ],
                    );
                  }).toList(),
                  ),
                )
              )
            ]
          );
        }
      ),
    );
  }
}