import 'package:flutter/material.dart';
import 'package:picking/navbar.dart';
import 'package:picking/play.dart';

import 'instrument.dart';
import 'routes.dart';
import 'start.dart';

void main() {
  runApp(const PickingApp());
}

class PickingApp extends StatelessWidget {
  const PickingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: PickingAppRoutes.home,
      onGenerateRoute: (settings) {
        Widget? page;
        String route = settings.name!;
        if (route == PickingAppRoutes.home) {
          page = const StartScreen();
        }
        Instrument? instrument = PickingAppRoutes.instrumentFromRoute(route);
        PlayMode? playMode = PickingAppRoutes.playModeFromRoute(route);
        if (instrument != null) {
          playMode ??= PlayMode.tabs;
          page = AppScreen(instrument, playMode);
        }

        assert(page != null, "paddle faster, i hear banjos!");

        return MaterialPageRoute<dynamic>(
          builder: (context) {
            return page!;
          },
          settings: settings,
        );
      },
    );
  }
}

class AppScreen extends StatelessWidget {
  final Instrument instrument;
  final PlayMode play;

  const AppScreen(this.instrument, this.play, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InstrumentModel(
        instrument: instrument,
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                const Navbar(),
                Flexible(
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(child: PlayScreen(play)),
                  ),
                ),
              ],
            )));
  }
}
