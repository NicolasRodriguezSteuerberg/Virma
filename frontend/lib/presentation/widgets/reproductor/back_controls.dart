import 'package:flutter/material.dart';
import 'package:frontend/presentation/viewmodels/watch_common_viewmodel.dart';

class BackControls extends StatelessWidget{
  final WatchCommonViewmodel vm;
  const BackControls({required this.vm, super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.black45,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: IconButton(
        onPressed: () => vm.onBackButtonPressed(context),
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white
        )
      )
    );
  }
}