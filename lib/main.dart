import 'package:flutter/material.dart';
import 'package:music_box/nav/navbar.dart';
import 'package:music_box/play.dart';

import 'instrument.dart';
import 'start.dart';

void main() {
  runApp(const MusicBoxApp());
}

class MusicBoxRoutes {
  static const String home = "/";

  static Instrument? instrumentFromRoute(String route) {
    if (route.startsWith("/banjo")) {
      return Instrument.banjo;
    } else if (route.startsWith("/guitar")) {
      return Instrument.guitar;
    } else {
      return null;
    }
  }
}

class MusicBoxApp extends StatelessWidget {
  const MusicBoxApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banjo Buddy',
      initialRoute: '/',
      onGenerateRoute: (settings) {
        Widget? page;
        String route = settings.name!;
        if (route == MusicBoxRoutes.home) {
          page = const StartScreen();
        }
        Instrument? instrument = MusicBoxRoutes.instrumentFromRoute(route);
        if (instrument != null) {
          page = AppScreen(instrument);
        }

        if (page == null) {
          throw Exception("wtf happened to your routing?");
        }

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

class AppScreen extends StatefulWidget {
  final Instrument instrument;

  const AppScreen(this.instrument, {Key? key}) : super(key: key);

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  late Instrument instrument;

  @override
  void initState() {
    super.initState();
    instrument = widget.instrument;
  }

  @override
  Widget build(BuildContext context) {
    return InstrumentModel(
        instrument: instrument,
        child: Scaffold(
            body: Column(
          children: [
            const Navbar(),
            Flexible(
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Navigator(
                    initialRoute: "paddle faster, i hear banjos",
                    onGenerateRoute: (settings) {
                      return MaterialPageRoute<dynamic>(
                        builder: (context) {
                          return const PlayScreen();
                        },
                        settings: settings,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        )));
  }
}
