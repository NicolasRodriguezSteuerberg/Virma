import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/watch_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Virma",
      home: WatchPage()
    );
  }
}