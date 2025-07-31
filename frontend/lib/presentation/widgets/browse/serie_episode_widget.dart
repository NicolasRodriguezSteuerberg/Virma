import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SerieEpisodeWidget extends StatelessWidget {
  final int episodeId;
  final int number;
  final String coverUrl;
  final int duration;
  final int? progress;

  const SerieEpisodeWidget({
    required this.episodeId, required this.number, required this.coverUrl,
    required this.duration, required this.progress
  });

  String convertDurationToTime() {
    int hours = duration ~/ 3600;
    int minutes = (duration % 3600) ~/ 60;
    int seconds = duration % 60;
    String minutesStr = "$minutes".padLeft(2, "0");
    String secondsStr = "$seconds".padLeft(2, "0");
    if (hours > 0){
      return "$hours:$minutesStr:$secondsStr";
    } 
    return "$minutesStr:$secondsStr";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push("/watch/serie/$episodeId"),
      child: Row(
        children: [
          SizedBox(
            width: 160,
            height: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  child: Image.network(
                    coverUrl,
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
                if (progress != null && progress! > 0) LinearProgressIndicator(
                  value: (progress!/duration).clamp(0, 1).toDouble(),
                  minHeight: 4,
                  backgroundColor: Colors.grey,
                  color: Colors.red,
                )
              ],
            )
          ),
          SizedBox(
            height: 250,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Capitulo $number",
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  convertDurationToTime(),
                )
              ],
            ))
          )          
        ],
      )
    );
  }

}