import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:picking/libtab/libtab.dart';

import 'instrument.dart';
import 'navbar.dart';
import 'practice.dart';
import 'timer.dart';

class DevRouter extends StatelessWidget {
  final Instrument instrument;

  const DevRouter(this.instrument, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InstrumentModel(
      instrument: instrument,
      child: Navigator(
        onGenerateRoute: (settings) {
          final path = settings.name!;
          if (kDebugMode) {
            print("dev $path");
          }
          if (path.contains("tabs")) {
            return MaterialPageRoute<dynamic>(
              builder: (context) => const DevScreen(TabsScreen()),
              settings: settings,
            );
          }
          if (path.contains("chords")) {
            return MaterialPageRoute<dynamic>(
              builder: (context) => const DevScreen(ChordsScreen()),
              settings: settings,
            );
          }

          return MaterialPageRoute<dynamic>(
            builder: (context) => const DevScreen(TimerScreen()),
            settings: settings,
          );
        },
      ),
    );
  }
}

class DevScreen extends StatelessWidget {
  final Widget child;

  const DevScreen(this.child, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const DevNavbar(),
            Flexible(
              child: SizedBox(
                width: double.infinity,
                // child: Center(child: PlayScreen(play)),
                child: child,
              ),
            ),
          ],
        ));
  }
}

class DevNavbar extends StatelessWidget {
  const DevNavbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final instrument = InstrumentModel.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
      child: Row(children: [
        const InstrumentSwap(),
        NavbarTextLink("Timer", "${instrument.path()}/timer"),
        NavbarTextLink("Tabs", "${instrument.path()}/tabs"),
        NavbarTextLink("Chord Chart", "${instrument.path()}/chords"),
        const Spacer(),
        const NavbarIcon(Icons.equalizer_rounded),
        const NavbarIcon(Icons.cast_rounded),
      ]),
    );
  }
}

class ChordsScreen extends StatelessWidget {
  const ChordsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final instrument = InstrumentModel.of(context);
    final tabContext =
        TabContext.forBrightness(MediaQuery.of(context).platformBrightness);
    switch (instrument) {
      case Instrument.banjo:
        return ChordChartDisplay(tabContext: tabContext, chord: BanjoChords.c);
      case Instrument.guitar:
        return ChordChartDisplay(
            tabContext: tabContext, chord: GuitarChords.am);
    }
  }
}

class TabsScreen extends StatelessWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final instrument = InstrumentModel.of(context);
    final tabContext =
        TabContext.forBrightness(MediaQuery.of(context).platformBrightness);
    return Padding(
      padding: const EdgeInsets.all(150),
      child: MeasureDisplay(
          Measure(notes: [
            Note(1, 12),
            null,
            Note(3, 11),
            Note(3, 11),
            Note(1, 12, and: Note(2, 10)),
            null,
            Note(1, 14, and: Note(2, 14))
          ]),
          instrument: instrument,
          tabContext: tabContext,
          last: true),
    );
  }
}

class TimerScreen extends StatelessWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabContext =
        TabContext.forBrightness(MediaQuery.of(context).platformBrightness);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: TimerFlow(
          onComplete: () {
            if (kDebugMode) {
              print('finished!');
            }
          },
          screenDuration: const Duration(seconds: 3),
          screens: [
            (context) => PracticeScreen(
                tabContext: tabContext, practice: BanjoRolls.forward),
            (context) => PracticeScreen(
                tabContext: tabContext, practice: BanjoRolls.backward),
            (context) => PracticeScreen(
                tabContext: tabContext, practice: BanjoRolls.forwardBackward),
            (context) => PracticeScreen(
                tabContext: tabContext, practice: BanjoRolls.alternatingThumb),
          ]),
    );
  }
}
