import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/viewmodels/browse_series_viewmodel.dart';
import 'package:frontend/presentation/widgets/browse/serie_film_card.dart';
import 'package:frontend/presentation/widgets/browse/share_app_bar.dart';
import 'package:provider/provider.dart';

class SeriesPage extends StatefulWidget {

  const SeriesPage({super.key});
  
  @override
  State<StatefulWidget> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // Llamamos en next frame para asegurar que el provider esté disponible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialized) {
        final vm = Provider.of<BrowseSeriesViewmodel>(context, listen: false);
        vm.fetchSeries();
        _initialized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ShareAppBar("/series"),
      body: Consumer<BrowseSeriesViewmodel>(builder: (context, vm, __) {
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
              childAspectRatio: 9/16
            ),
            itemCount: vm.series.length,
            itemBuilder: (_, i) {
              return SerieFilmCard(
                id: vm.series[i].id, 
                title: vm.series[i].title, 
                imageUrl: vm.series[i].coverUrl,
                isSerie: true,
              );
            },
          ));
      }),
    );
  }
  
}