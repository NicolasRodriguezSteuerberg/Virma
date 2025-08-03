import 'package:flutter/material.dart';
import 'package:frontend/presentation/viewmodels/serie_viewmodel.dart';
import 'package:frontend/presentation/widgets/browse/serie_episode_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SeriePage extends StatefulWidget{

  const SeriePage({super.key});


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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Virma"),
        leading: IconButton(
          onPressed: () => context.push("/series"),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          )
        )
      ),
      body: Consumer<SerieViewmodel>(
        builder: (context, vm, __) {
          if (vm.loading) return const Center(child: CircularProgressIndicator(),);
          if (vm.error) return const Center(child: Text("Error recogiendo la informacion de la serie"),);
          return Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: SizedBox(
                      height: 250,
                      child: Image.network(
                        vm.serie!.coverUrl,
                        fit: BoxFit.cover,
                        errorBuilder:(context, error, stackTrace) => Container(
                          color: Colors.grey,
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image, size: 160),
                        ),
                        loadingBuilder:(context, child, loadingProgress) => 
                          loadingProgress == null
                            ? child
                            : Container(
                              color: Colors.grey,
                              child: Center(child: CircularProgressIndicator())
                            ),
                      )
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            vm.serie!.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(vm.serie!.description)
                        ),
                      ],
                    ),
                  )    
                ],
              ),
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