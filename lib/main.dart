import 'package:flutter/material.dart';
import 'controller.dart';
import 'router.dart';
import 'theme.dart';
import 'ui.dart';

void main() {
  runApp(PickingApp());
}

class PickingApp extends StatelessWidget {
  final controller = PickingControllerApi();

  PickingApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = PickingThemeData.darkBlue();
    return MaterialApp(
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        home: PickingTheme(
            theme: theme,
            child: Scaffold(
                backgroundColor: theme.backgroundColor,
                body: SafeArea(
                    child: PickingController(
                        controller: controller,
                        child: UserInterface(
                            controller: controller,
                            child: const PickingRouter()))))));
  }
}
