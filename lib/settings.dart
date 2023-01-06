import 'package:flutter/material.dart';

class SettingsRoute extends StatelessWidget {
  static WidgetBuilder builder = (context) => const SettingsRoute();

  const SettingsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(child: Center(child: Text('settings')));
  }
}
