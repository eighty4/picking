import 'package:picking/libtab/libtab.dart';

enum NavPath { pairings, root, songs }

extension NavPathFns on NavPath {
  String join(String base) {
    return '$base/$name';
  }
}

class PickingRoutes {
  static const launch = '/';

  static const chords = '/chords';

  static const chordById = '/chord';

  static const settings = '/settings';

  static const songs = '/songs';

  static const songById = '/song';

  static const techniques = '/techniques';

  static const techniqueById = '/technique';

  static String chord(Chord chord) {
    return '/chord/${chord.id()}';
  }

  static String chordPairing(Chord a, Chord b, {NavPath? path}) {
    final base = '/chords/${a.id()},${b.id()}';
    return path == null ? base : path.join(base);
  }

  static String song(String id) {
    return '/song/$id';
  }

  static String technique(Technique technique, {NavPath? path}) {
    final base = '/technique/${technique.name}';
    return path == null ? base : path.join(base);
  }
}

class PickingRouteMatchers {
  static final chordRouteMatcher = RegExp(r'^/chord/([a-z\d]+)$');
  static final chordPairingRouteMatcher =
      RegExp(r'^/chords/([a-z\d]+,[a-z\d]+)(?:/(pairings|songs))?$');
  static final songRouteMatcher =
      RegExp(r'^/song/([a-z](?:[a-z\d]+)?(?:-[a-z](?:[a-z\d]+)?)*)$');
  static final techniqueRouteMatcher =
      RegExp(r'^/technique/(hammerOn|pullOff|slide)(?:/(pairings|songs))?$');

  static String basePath(String path) {
    final basePathEnd = path.indexOf('/', 1);
    return basePathEnd == -1 ? path : path.substring(0, basePathEnd);
  }

  static ChordRouteArguments? chordRoute(String path) {
    final match = chordRouteMatcher.firstMatch(path);
    if (match == null) {
      return null;
    }
    final chordId = match.group(1);
    if (chordId == null) {
      return null;
    }
    try {
      final chord = Chord.values.byName(chordId);
      return ChordRouteArguments(chord);
    } on ArgumentError {
      return null;
    }
  }

  static ChordPairingRouteArguments? chordPairingRoute(String path) {
    final match = chordPairingRouteMatcher.firstMatch(path);
    if (match == null) {
      return null;
    }
    final chordIds = match.group(1);
    if (chordIds == null) {
      return null;
    }
    final chordIdsSplit = chordIds.split(',');
    if (chordIdsSplit.length != 2) {
      return null;
    }
    final navPathId = match.groupCount == 2 ? match.group(2) : null;
    try {
      final chord1 = Chord.values.byName(chordIdsSplit[0]);
      final chord2 = Chord.values.byName(chordIdsSplit[1]);
      final navPath =
          navPathId == null ? null : NavPath.values.byName(navPathId);
      return ChordPairingRouteArguments(chord1, chord2, navPath);
    } on ArgumentError {
      return null;
    }
  }

  static SongRouteArguments? songRoute(String path) {
    final match = songRouteMatcher.firstMatch(path);
    if (match == null) {
      return null;
    }
    final songId = match.group(1);
    if (songId == null) {
      return null;
    }
    return SongRouteArguments(songId);
  }

  static TechniqueRouteArguments? techniqueRoute(String path) {
    final match = techniqueRouteMatcher.firstMatch(path);
    if (match == null) {
      return null;
    }
    final techniqueId = match.group(1);
    if (techniqueId == null) {
      return null;
    }
    final navPathId = match.groupCount == 2 ? match.group(2) : null;
    try {
      final technique = Technique.values.byName(techniqueId);
      final navPath =
          navPathId == null ? null : NavPath.values.byName(navPathId);
      return TechniqueRouteArguments(technique, navPath);
    } on ArgumentError {
      return null;
    }
  }
}

class ChordRouteArguments {
  final Chord chord;

  ChordRouteArguments(this.chord);
}

class ChordPairingRouteArguments {
  final Chord chord1;
  final Chord chord2;
  final NavPath? path;

  ChordPairingRouteArguments(this.chord1, this.chord2, [this.path]);
}

class SongRouteArguments {
  final String songId;

  SongRouteArguments(this.songId);
}

class TechniqueRouteArguments {
  final Technique technique;
  final NavPath? path;

  TechniqueRouteArguments(this.technique, [this.path]);
}
