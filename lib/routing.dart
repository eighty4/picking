import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class PickingRoutes {
  static const launch = '/';
  static const playChords = '/play/chords';
}

extension PickingNavigation on BuildContext {
  playChords() {
    go(PickingRoutes.playChords);
  }

  navTo(String route) {
    go(route);
  }
}
