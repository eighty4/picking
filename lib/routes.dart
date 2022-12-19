import 'instrument.dart';

class PickingAppRoutes {
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
