import 'package:flutter/material.dart';

import 'theme.dart';

class LaunchRoute extends StatelessWidget {
  static WidgetBuilder builder = (context) => const LaunchRoute();

  const LaunchRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(child: Center(child: ThemeStyledText('launch')));
  }
}
