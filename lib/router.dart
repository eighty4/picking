import 'package:flutter/material.dart';

import 'chords.dart';
import 'launch.dart';
import 'routes.dart';
import 'settings.dart';
import 'songs.dart';
import 'techniques.dart';

class PickingRouter extends StatelessWidget {
  static GlobalKey<NavigatorState> routerKey = GlobalKey<NavigatorState>();

  static NavigatorState get navigator {
    return routerKey.currentState!;
  }

  const PickingRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: routerKey,
      initialRoute: '/',
      onGenerateRoute: _onGenerateRoute,
      onUnknownRoute: _onUnknownRoute,
    );
  }

  Route? _onGenerateRoute(RouteSettings settings) {
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
            final chordRouteArguments = PickingRouteMatchers.chordRoute(path);
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
                  name: PickingRoutes.songById, arguments: songRouteArguments);
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
      return PickingPageRoute(builder: builder, settings: updatedSettings);
    }
  }

  Route? _onUnknownRoute(RouteSettings settings) {
    return PickingPageRoute(builder: (context) => const FlutterLogo());
  }
}

class PickingPageRoute<T> extends ModalRoute<T> {
  final WidgetBuilder builder;

  PickingPageRoute({required this.builder, super.settings});

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: builder(context),
    );
  }

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => "PickingPageRoute.barrier";

  @override
  bool get maintainState => false;

  @override
  bool get opaque => true;

  @override
  Duration get transitionDuration => Duration.zero;
}
