import 'package:flutter/material.dart';

import 'chords.dart';
import 'controller.dart';
import 'launch.dart';
import 'routes.dart';
import 'settings.dart';
import 'songs.dart';
import 'techniques.dart';

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
        WidgetBuilder? builder;
        RouteSettings? updatedSettings;
        switch (path) {
          case PickingRoutes.launch:
            builder = LaunchRoute.builder;
            break;
          case PickingRoutes.chords:
            builder = ChordsRoute.builder;
            break;
          case PickingRoutes.settings:
            builder = SettingsRoute.builder;
            break;
          case PickingRoutes.songs:
            builder = SongsRoute.builder;
            break;
          case PickingRoutes.techniques:
            builder = TechniquesRoute.builder;
            break;
          default:
            final basePath = PickingRouteMatchers.basePath(path);
            switch (basePath) {
              case PickingRoutes.chordById:
                final chordRouteArguments =
                    PickingRouteMatchers.chordRoute(path);
                if (chordRouteArguments != null) {
                  builder = ChordsRoute.builder;
                  updatedSettings = RouteSettings(
                      name: PickingRoutes.chordById,
                      arguments: chordRouteArguments);
                }
                break;
              case PickingRoutes.chords:
                final chordPairingRouteArguments =
                    PickingRouteMatchers.chordPairingRoute(path);
                if (chordPairingRouteArguments != null) {
                  builder = ChordsRoute.builder;
                  updatedSettings = RouteSettings(
                      name: PickingRoutes.chords,
                      arguments: chordPairingRouteArguments);
                }
                break;
              case PickingRoutes.songById:
                final songRouteArguments = PickingRouteMatchers.songRoute(path);
                if (songRouteArguments != null) {
                  builder = SongsRoute.builder;
                  updatedSettings = RouteSettings(
                      name: PickingRoutes.songById,
                      arguments: songRouteArguments);
                }
                break;
              case PickingRoutes.techniqueById:
                final techniqueRouteArguments =
                    PickingRouteMatchers.techniqueRoute(path);
                if (techniqueRouteArguments != null) {
                  builder = TechniquesRoute.builder;
                  updatedSettings = RouteSettings(
                      name: PickingRoutes.techniqueById,
                      arguments: techniqueRouteArguments);
                }
                break;
            }
        }
        if (builder == null) {
          return null;
        } else {
          return _createRoute(builder, settings: updatedSettings);
        }
      },
      onUnknownRoute: (settings) {
        return _createRoute((context) => const FlutterLogo());
      },
    );
  }

  PickingPageRoute _createRoute(WidgetBuilder builder,
      {RouteSettings? settings}) {
    return PickingPageRoute(
        pickingController: controller, settings: settings, builder: builder);
  }
}
