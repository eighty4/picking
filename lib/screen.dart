import 'package:flutter/material.dart';

import 'theme.dart';

class PickingScreen extends StatelessWidget {
  final Widget child;

  const PickingScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final background = PickingTheme.of(context).backgroundColor;
    return Container(color: background, child: child);
  }
}
