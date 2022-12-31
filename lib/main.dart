import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'controller.dart';
import 'routes.dart';
import 'screens.dart';

void main() {
  runApp(PickingApp());
}

class PickingApp extends StatelessWidget {
  final PickingController controller = PickingController();

  PickingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      onGenerateRoute: (settings) {
        assert(settings.name != null);
        final path = settings.name!;
        if (kDebugMode) {
          print(path);
        }
        return PickingPageRoute(
            pickingController: controller,
            builder: (context) =>
                PracticeScreen(pickingController: controller));
      },
    );
  }
}
