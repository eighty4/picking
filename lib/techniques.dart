import 'package:flutter/material.dart';

import 'routes.dart';
import 'theme.dart';

class TechniquesRoute extends StatelessWidget {
  static WidgetBuilder builder = (context) => const TechniquesRoute();

  const TechniquesRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (routeArgs is TechniqueRouteArguments) {
      if (routeArgs.path != null) {
        return Center(
            child: ThemeStyledText(
                'technique ${routeArgs.technique.name} ${routeArgs.path!.name}'));
      } else {
        return Center(
            child: ThemeStyledText('technique ${routeArgs.technique.name}'));
      }
    } else {
      return const Center(child: ThemeStyledText('techniques'));
    }
  }
}
