import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/config/url_strategy/url_strategy.dart';
import 'package:frontend/presentation/pages/login_page.dart';
import 'package:frontend/presentation/pages/movie_watch_page.dart';
import 'package:frontend/presentation/pages/movies_page.dart';
import 'package:frontend/presentation/pages/serie_page.dart';
import 'package:frontend/presentation/pages/serie_watch_page.dart';
import 'package:frontend/presentation/pages/series_page.dart';
import 'package:frontend/presentation/pages/splash_page.dart';
import 'package:frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:frontend/presentation/viewmodels/movie_watch_viewmodel.dart';
import 'package:frontend/presentation/viewmodels/movies_viewmodel.dart';
import 'package:frontend/presentation/viewmodels/browse_series_viewmodel.dart';
import 'package:frontend/presentation/viewmodels/serie_viewmodel.dart';
import 'package:frontend/presentation/viewmodels/watch_serie_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';


String? _intendedLocation = null;

void main() async{
  await dotenv.load(fileName: ".env");
  setPathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  runApp(ChangeNotifierProvider(
    create: (_) => AuthProvider(),
    child: const MyApp(),
  ));
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
    final auth = Provider.of<AuthProvider>(context);
    return MaterialApp.router(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      title: "Virma",
      routerConfig: GoRouter(
        refreshListenable: auth,
        initialLocation: (_intendedLocation == null || _intendedLocation!.isEmpty)
          ? '/movies'
          : _intendedLocation,
        redirect: (context, state) {
          final isAuth = auth.isAuthenticated;
          final isLoading = auth.isLoading;
          final isLoggingIn = state.matchedLocation == '/login';
          final isSplash = state.matchedLocation == '/splash';

          if (isLoading) {
            if (!isSplash){
              _intendedLocation = state.matchedLocation;
              return '/splash';
            }
            return null;
          }

          if (!isAuth && !isLoggingIn) {
            return '/login';
          }

          if (isAuth && isLoggingIn) {
            return '/movies';
          }
          return null;
        },
        routes: [
          GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
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
              final int id = int.parse(state.pathParameters["id"]!);
              return ChangeNotifierProvider(
                key: ValueKey(id),
                create: (_) => SerieViewmodel(id),
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
                create: (_) => MovieWatchViewmodel(auth),
                child: MovieWatchPage(filmId: args,),
              );
            }
          ),
          GoRoute(
            path: "/watch/serie/:episodeId",
            builder: (context, state) {
              final String args = state.pathParameters["episodeId"]!;
              return ChangeNotifierProvider(
                create: (_) => WatchSerieViewmodel(auth),
                child: SerieWatchPage(episodeId: args),
              );
            },
          ),
        ]
      )
    );
  }
}