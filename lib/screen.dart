import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme.dart';

class PickingScreen extends StatelessWidget {
  final Widget child;

  const PickingScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = PickingTheme.of(context);
    return Scaffold(
        backgroundColor: theme.backgroundColor,
        body: SafeArea(
            child: DefaultTextStyle(
                style: GoogleFonts.cormorant()
                    .copyWith(color: theme.textColor, letterSpacing: 1.25),
                child: child)));
  }
}
