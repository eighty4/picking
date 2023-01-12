import 'package:flutter/material.dart';
import 'package:picking/libtab/libtab.dart';

import 'banjo.dart';
import 'routes.dart';
import 'theme.dart';

class ChordsRoute extends StatelessWidget {
  static WidgetBuilder builder = (context) => const ChordsRoute();

  const ChordsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (routeArgs is ChordRouteArguments) {
      return Center(child: ThemeStyledText('chord ${routeArgs.chord.id()}'));
    } else if (routeArgs is ChordPairingRouteArguments) {
      if (routeArgs.path != null) {
        return Center(
            child: ThemeStyledText(
                'chords ${routeArgs.chord1.id()} and ${routeArgs.chord2.id()} ${routeArgs.path!.name}'));
      } else {
        return Center(
            child: ThemeStyledText(
                'chords ${routeArgs.chord1.id()} and ${routeArgs.chord2.id()}'));
      }
    } else {
      final tabContext = PickingTheme.of(context).tabContext();
      return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        MeasureDisplay(BanjoRolls.forward,
            instrument: Instrument.banjo, tabContext: tabContext),
        ChordChartDisplay(
            size: const Size(100, 125),
            tabContext: tabContext,
            chord: BanjoChords.c)
      ]);
    }
  }
}
