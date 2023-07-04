import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:libtab/libtab.dart';

import 'chords.dart';
import 'controller.dart';
import 'instrument.dart';
import 'launch.dart';
import 'routing.dart';
import 'theme.dart';
import 'ui.dart';

GlobalKey<NavigatorState> _appNavKey = GlobalKey();

GlobalKey<NavigatorState> _playNavKey = GlobalKey();

RouterConfig<Object> buildRouter(PickingControllerApi controller) {
  if (kDebugMode) {
    _appNavKey = GlobalKey();
    _playNavKey = GlobalKey();
  }
  return GoRouter(
      navigatorKey: _appNavKey,
      initialLocation: PickingRoutes.launch,
      routes: [
        GoRoute(
          path: PickingRoutes.launch,
          builder: (context, state) => const LaunchRoute(),
        ),
        ShellRoute(
            navigatorKey: _playNavKey,
            builder: (context, state, child) {
              final theme = PickingThemeData.darkBlue();
              return PickingTheme(
                  theme: theme,
                  child: InitializeInstrumentModel(
                    child: Scaffold(
                        backgroundColor: theme.backgroundColor,
                        body: SafeArea(
                            child: UserInterface(
                                controller: controller, child: child))),
                  ));
            },
            routes: <RouteBase>[
              GoRoute(
                path: PickingRoutes.browseChords,
                builder: (context, state) {
                  return const ChordsMenuRoute();
                },
              ),
              GoRoute(
                path: PickingRoutes.playChord,
                builder: (context, state) {
                  final chordPathParam = state.pathParameters['chord']!;
                  try {
                    final chord = Chord.values.byName(chordPathParam);
                    return PlayChordRoute(chord);
                  } on ArgumentError {
                    return BadRouteRedirect(
                        "We don't know how to play the \"$chordPathParam\" chord");
                  }
                },
              ),
            ])
      ]);
}

class BadRouteRedirect extends StatelessWidget {
  final String message;

  const BadRouteRedirect(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message),
        Padding(
            padding: const EdgeInsets.only(top: 20),
            child: MaterialButton(
                onPressed: () {
                  context.browseChords();
                },
                color: Colors.red,
                child: const Text('Back')))
      ],
    );
  }
}
