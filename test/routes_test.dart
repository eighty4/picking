import 'package:flutter_test/flutter_test.dart';
import 'package:libtab/libtab.dart';
import 'package:picking/routes.dart';

void main() {
  test('PickingRoutes.chord', () {
    expect(PickingRoutes.chord(Chord.a), equals('/chord/a'));
  });
  test('PickingRoutes.chordPairing', () {
    expect(PickingRoutes.chordPairing(Chord.a, Chord.c), equals('/chords/a,c'));
  });
  test('PickingRoutes.song', () {
    expect(PickingRoutes.song('foo'), equals('/song/foo'));
  });
  test('PickingRoutes.technique', () {
    expect(PickingRoutes.technique(Technique.hammerOn),
        equals('/technique/hammerOn'));
  });
  test('PickingRouteMatchers.chordRoute', () {
    expect(PickingRouteMatchers.songRoute('/chord'), isNull);
    expect(PickingRouteMatchers.songRoute('/chord/1'), isNull);
    final happyPath = PickingRouteMatchers.chordRoute('/chord/a');
    expect(happyPath, isNotNull);
    expect(happyPath!.chord, equals(Chord.a));
  });
  test('PickingRouteMatchers.chordPairingRoute', () {
    expect(PickingRouteMatchers.songRoute('/chord/a,c'), isNull);
    expect(PickingRouteMatchers.songRoute('/chords/foo,bar'), isNull);
    expect(PickingRouteMatchers.songRoute('/chords/a,c/asdf'), isNull);
    final happyPath = PickingRouteMatchers.chordPairingRoute('/chords/a,c');
    expect(happyPath, isNotNull);
    expect(happyPath!.chord1, equals(Chord.a));
    expect(happyPath.chord2, equals(Chord.c));
  });
  test('PickingRouteMatchers.songRoute', () {
    expect(PickingRouteMatchers.songRoute('/song'), isNull);
    expect(PickingRouteMatchers.songRoute('/songs'), isNull);
    expect(PickingRouteMatchers.songRoute('/songs/foo'), isNull);
    expect(PickingRouteMatchers.songRoute('/song/1'), isNull);
    expect(PickingRouteMatchers.songRoute('/song/foo/bar'), isNull);
    final happyPath = PickingRouteMatchers.songRoute('/song/foo');
    expect(happyPath, isNotNull);
    expect(happyPath!.songId, equals('foo'));
  });
  test('PickingRouteMatchers.techniqueRoute', () {
    expect(PickingRouteMatchers.songRoute('/technique'), isNull);
    expect(PickingRouteMatchers.songRoute('/technique/foo'), isNull);
    expect(PickingRouteMatchers.songRoute('/technique/slide/asdf'), isNull);
    expect(PickingRouteMatchers.songRoute('/techniques/slide'), isNull);
    final happyPath = PickingRouteMatchers.techniqueRoute('/technique/pullOff');
    expect(happyPath, isNotNull);
    expect(happyPath!.technique, equals(Technique.pullOff));
  });
}
