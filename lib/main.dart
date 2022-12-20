import 'package:flutter/material.dart';

import 'dev.dart';
import 'instrument.dart';
import 'routes.dart';
import 'start.dart';
import 'tv.dart';

void main() {
  runApp(const TvApp());
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
        if (instrument != null) {
          page = DevRouter(instrument);
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
