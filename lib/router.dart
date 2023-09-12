import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:libtab/libtab.dart';

import 'chords.dart';
import 'controller.dart';
import 'instrument.dart';
import 'launch.dart';
import 'play.dart';
import 'routing.dart';
import 'screen.dart';
import 'techniques.dart';
import 'theme.dart';
import 'ui.dart';

const initialLocation = PickingRoutes.launch;

GlobalKey<NavigatorState> _appNavKey = GlobalKey();

GlobalKey<NavigatorState> _playNavKey = GlobalKey();

RouterConfig<Object> buildRouter(PickingControllerApi controller) {
  if (kDebugMode) {
    _appNavKey = GlobalKey();
    _playNavKey = GlobalKey();
  }
  return GoRouter(
      navigatorKey: _appNavKey,
      initialLocation: initialLocation,
      errorBuilder: (context, state) =>
          const PickingScreen(child: BadRouteRedirect.notFound()),
      routes: [
        GoRoute(
          path: PickingRoutes.launch,
          builder: (context, state) => const LaunchRoute(),
        ),
        ShellRoute(
            navigatorKey: _playNavKey,
            builder: (context, state, child) {
              return InitializeInstrumentModel(
                child: PickingScreen(
                    child: UserInterface(controller: controller, child: child)),
              );
            },
            routes: <RouteBase>[
              GoRoute(
                path: PickingRoutes.browseChords,
                builder: (context, state) => const BrowseChords(),
              ),
              GoRoute(
                path: PickingRoutes.browseTechniques,
                builder: (context, state) => const BrowseTechniques(),
              ),
              GoRoute(
                path: PickingRoutes.browseSongs,
                builder: (context, state) =>
                    const PlaceholderRoute(route: PickingRoutes.browseSongs),
              ),
              GoRoute(
                path: PickingRoutes.playChord,
                builder: (context, state) {
                  final chordPathParam = state.pathParameters['chord']!;
                  try {
                    return PlayChord(Chord.values.byName(chordPathParam));
                  } on ArgumentError {
                    return BadRouteRedirect(
                        "We don't know how to play the \"$chordPathParam\" chord");
                  }
                },
              ),
              GoRoute(
                path: PickingRoutes.playMusic,
                builder: (context, state) => const PlayMusic(),
              ),
            ])
      ]);
}

class PlaceholderRoute extends StatelessWidget {
  final String route;

  const PlaceholderRoute({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(route));
  }
}

class BadRouteRedirect extends StatelessWidget {
  final String message;
  final String buttonText;

  const BadRouteRedirect(this.message, {super.key, this.buttonText = 'Back'});

  const BadRouteRedirect.notFound({super.key})
      : message =
            "The ${kIsWeb ? 'page' : 'screen'} you're trying to reach does not exist.",
        buttonText = 'Start over';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Text(message)),
        const SizedBox(height: 20),
        MaterialButton(
            onPressed: () {
              context.browseChords();
            },
            // todo can this be configured with a material app theme?
            color: PickingTheme.of(context).actionColor,
            child: Text(buttonText)),
      ],
    );
  }
}
