import 'package:flutter/material.dart';

import 'controller.dart';
import 'router.dart';

void main() {
  runApp(const PickingApp());
}

class PickingApp extends StatelessWidget {
  const PickingApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PickingControllerApi();
    return PickingController(
        controller: controller,
        child: MaterialApp.router(
            theme: ThemeData.light(useMaterial3: true),
            darkTheme: ThemeData.dark(useMaterial3: true),
            routerConfig: buildRouter(controller)));
  }
}
