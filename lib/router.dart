import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'chords.dart';
import 'controller.dart';
import 'launch.dart';
import 'routing.dart';
import 'theme.dart';
import 'ui.dart';

final GlobalKey<NavigatorState> _appNavKey = GlobalKey<NavigatorState>();

final GlobalKey<NavigatorState> _playNavKey = GlobalKey<NavigatorState>();

RouterConfig<Object> buildRouter(PickingControllerApi controller) {
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
                  child: Scaffold(
                      backgroundColor: theme.backgroundColor,
                      body: SafeArea(
                          child: UserInterface(
                              controller: controller, child: child))));
            },
            routes: <RouteBase>[
              GoRoute(
                path: PickingRoutes.playChords,
                builder: (context, state) {
                  return ChordsRoute.builder(context);
                },
              ),
            ])
      ]);
}
