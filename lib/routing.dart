import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:libtab/chord.dart';

class PickingRoutes {
  static const launch = '/';
  static const playMusic = '/play';
  static const browseChords = '/browse/chords';
  static const browseSongs = '/browse/songs';
  static const browseTechniques = '/browse/techniques';
  static const playChord = '/play/chord/:chord';
}

extension PickingNavigation on BuildContext {
  playMusic() {
    go(PickingRoutes.playMusic);
  }

  browseChords() {
    go(PickingRoutes.browseChords);
  }

  playChord(Chord chord) {
    go(PickingRoutes.playChord.replaceFirst(':chord', chord.name));
  }

  navTo(String route) {
    go(route);
  }
}
