import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controller.dart';
import 'router.dart';
import 'theme.dart';

void main() {
  if (kReleaseMode) {
    GoogleFonts.config.allowRuntimeFetching = false;
  }
  runApp(const PickingApp());
}

class PickingApp extends StatelessWidget {
  const PickingApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PickingControllerApi();
    return FontPreload(
      child: PickingTheme(
        theme: PickingThemeData.darkBlue(),
        child: PickingController(
            controller: controller,
            child: MaterialApp.router(
                title: kIsWeb
                    ? "Picking - bluegrass banjo & guitar for beginners"
                    : "Picking",
                theme: ThemeData.light(useMaterial3: true),
                darkTheme: ThemeData.dark(useMaterial3: true),
                routerConfig: buildRouter(controller))),
      ),
    );
  }
}
