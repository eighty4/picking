import 'package:flutter/material.dart';
import 'package:libtab/libtab.dart';

import 'banjo.dart';
import 'theme.dart';

class ChordsRoute extends StatelessWidget {
  const ChordsRoute({super.key});

  @override
  Widget build(BuildContext context) {
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
