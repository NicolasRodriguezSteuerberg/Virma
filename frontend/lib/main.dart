import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:frontend/presentation/pages/movie_watch_page.dart';
import 'package:frontend/presentation/pages/movies_page.dart';
import 'package:frontend/presentation/pages/serie_page.dart';
import 'package:frontend/presentation/pages/serie_watch_page.dart';
import 'package:frontend/presentation/pages/series_page.dart';
import 'package:frontend/presentation/viewmodels/movie_watch_viewmodel.dart';
import 'package:frontend/presentation/viewmodels/movies_viewmodel.dart';
import 'package:frontend/presentation/viewmodels/browse_series_viewmodel.dart';
import 'package:frontend/presentation/viewmodels/serie_viewmodel.dart';
import 'package:frontend/presentation/viewmodels/watch_serie_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() async{
  await dotenv.load(fileName: ".env");
  setUrlStrategy(PathUrlStrategy());
  GoRouter.optionURLReflectsImperativeAPIs = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  /*
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Virma",
      routes: {
        "/series": (_) => ChangeNotifierProvider(
          create: (_) => SeriesViewmodel(),
          child: SeriesPage(),
        ),
        "/movies": (_) => ChangeNotifierProvider(
          create: (_) => MoviesViewmodel(),
          child: MoviesPage(),
        ),
        "/watch/movie": (context) => MovieWatchPage()
      },
      initialRoute: "/series",
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "Virma",
      initialRoute: "/series",
      onGenerateRoute: (settings) {
        switch(settings.name) {
          case '/':
          case '/series':
            return MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (_) => SeriesViewmodel(),
                child: SeriesPage()
              )
            );
          case '/movies':
            return MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (_) => MoviesViewmodel(),
                child: MoviesPage()
              )
            );

        }
      },
    );
  }
  */
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Virma",
      routerConfig: GoRouter(
        initialLocation: "/movies",
        routes: [
          GoRoute(
            path: "/series",
            builder: (context, state) => ChangeNotifierProvider(
              create: (_) => BrowseSeriesViewmodel(),
              child: const SeriesPage(),
            ),
          ),
          GoRoute(
            path: "/serie/:id",
            builder: (context, state) {
              final String args = state.pathParameters["id"]!;
              return ChangeNotifierProvider(
                create: (_) => SerieViewmodel(int.parse(args)),
                child: SeriePage(),
              );
            },
          ),
          GoRoute(
            path: "/movies",
            builder: (context, state) => ChangeNotifierProvider(
              create: (_) => MoviesViewmodel(),
              child: const MoviesPage(),
            ),
          ),
          GoRoute(
            path: "/watch/movie/:id",
            builder: (context, state) {
              print("HOLAAA????");
              final String args = state.pathParameters["id"]!;
              return ChangeNotifierProvider(
                create: (_) => MovieWatchViewmodel(),
                child: MovieWatchPage(filmId: args,),
              );
            }
          ),
          GoRoute(
            path: "/watch/serie/:episodeId",
            builder: (context, state) {
              final String args = state.pathParameters["episodeId"]!;
              return ChangeNotifierProvider(
                create: (_) => WatchSerieViewmodel(),
                child: SerieWatchPage(episodeId: args),
              );
            },
          ),
        ]
      )
    );
  }
}