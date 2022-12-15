import 'instrument.dart';

enum PlayMode { chords, tabs }

class PickingAppRoutes {
  static const String home = "/";

  static String chords(Instrument instrument) {
    return "${instrument.path()}/chords";
  }

  static String tabs(Instrument instrument) {
    return "${instrument.path()}/tabs";
  }

  static Instrument? instrumentFromRoute(String route) {
    if (route.startsWith("/banjo")) {
      return Instrument.banjo;
    } else if (route.startsWith("/guitar")) {
      return Instrument.guitar;
    } else {
      return null;
    }
  }

  static PlayMode? playModeFromRoute(String route) {
    if (route.endsWith("/chords")) {
      return PlayMode.chords;
    } else if (route.endsWith("/tabs")) {
      return PlayMode.tabs;
    } else {
      return null;
    }
  }
}
