import 'package:web/web.dart' as web;

void enterFullscreen() {
  final elem = web.document.documentElement;
  if (elem != null) {
    elem.requestFullscreen();
  }
}

void exitFullscreen() {
  if (web.document.fullscreenElement != null) {
    web.document.exitFullscreen();
  }
}
