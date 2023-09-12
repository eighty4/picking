import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:libtab/chord.dart';

enum NavSection { chords, songs, techniques }

class PickingRoutes {
  static const launch = '/';
  static const playMusic = '/play';
  static const browseChords = '/browse/chords';
  static const browseSongs = '/browse/songs';
  static const browseTechniques = '/browse/techniques';
  static const playChord = '/play/chord/:chord';
}

extension PickingNavigation on BuildContext {
  launch() {
    go(PickingRoutes.launch);
  }

  playMusic() {
    go(PickingRoutes.playMusic);
  }

  browseChords() {
    go(PickingRoutes.browseChords);
  }

  browseTechniques() {
    go(PickingRoutes.browseTechniques);
  }

  playChord(Chord chord) {
    go(PickingRoutes.playChord.replaceFirst(':chord', chord.name));
  }

  String? currentRoute() => GoRouterState.of(this).fullPath;

  NavSection? currentNavSection() {
    final currentRoute = this.currentRoute();
    if (currentRoute != null) {
      if (currentRoute.startsWith('/browse/')) {
        return switch (currentRoute.substring(8)) {
          'chords' => NavSection.chords,
          'techniques' => NavSection.techniques,
          'songs' => NavSection.songs,
          _ => null,
        };
      }
    }
    return null;
  }
}
