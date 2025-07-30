import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShareAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String currentRoute;

  const ShareAppBar(this.currentRoute, {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      title: Text("Virma"),
      actions: [
        _NavButton("Series", "/series", currentRoute),
        _NavButton("Peliculas", "/movies", currentRoute)
      ],
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}

class _NavButton extends StatelessWidget {
  final String label;
  final String route;
  final String currentRoute;

  const _NavButton(this.label, this.route, this.currentRoute);

  @override
  Widget build(BuildContext context) {
    final bool selected = currentRoute == route;
    return TextButton(
      onPressed: selected
        ? null
        : () =>  context.push(route)
      ,
      child: Text(
        label,
        style: TextStyle(
          fontWeight: selected ? FontWeight.bold : FontWeight.normal
        )
        
      )
    );
  }
}