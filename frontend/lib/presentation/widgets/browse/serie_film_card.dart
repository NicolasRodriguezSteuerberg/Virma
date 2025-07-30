import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SerieFilmCard extends StatelessWidget{
  final int id;
  final String title;
  final String imageUrl;
  final bool isSerie;
  final int? progress;
  final int? duration;

  const SerieFilmCard(
    {required this.id, required this.title, required this.imageUrl, this.isSerie = true, this.progress, this.duration, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 250,
      child: GestureDetector(
        onTap: () => context.push("/watch/movie/$id"),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              child: Image.network(
                imageUrl,
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
              ),
            ),
            if (progress!=null && progress! > 0) LinearProgressIndicator(
              value: (progress!/duration!).clamp(0, 1).toDouble(),
              minHeight: 4,
              backgroundColor: Colors.grey,
              color: Colors.red
            )
          ],
        ),
      ) 
    );
  }
}