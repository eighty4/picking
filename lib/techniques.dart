import 'package:flutter/material.dart';

import 'routes.dart';

class TechniquesRoute extends StatelessWidget {
  static WidgetBuilder builder = (context) => const TechniquesRoute();

  const TechniquesRoute({super.key});

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.settings.arguments is TechniqueRouteArguments) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as TechniqueRouteArguments;
      if (arguments.path != null) {
        return Expanded(
            child: Center(
                child: Text(
                    'technique ${arguments.technique.name} ${arguments.path!.name}')));
      } else {
        return Expanded(
            child:
                Center(child: Text('technique ${arguments.technique.name}')));
      }
    } else {
      return const Expanded(child: Center(child: Text('techniques')));
    }
  }
}
