import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackControls extends StatelessWidget{
  final String route;
  const BackControls({required this.route, super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.black45,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: IconButton(
        onPressed: () => context.go(route),
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white
        )
      )
    );
  }
}