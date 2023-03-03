import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libtab/libtab.dart';

class PickingThemeData {
  final Color backgroundColor;
  final Color chartColor;
  final Color metronomeBarColor;
  final Color metronomeNoteColor;
  final Color navigationColor;
  final Color noteColor;
  final Color noteLabelColor;
  final Color textColor;

  const PickingThemeData(
      {required this.backgroundColor,
      required this.chartColor,
      required this.metronomeBarColor,
      required this.metronomeNoteColor,
      required this.navigationColor,
      required this.noteColor,
      required this.noteLabelColor,
      required this.textColor});

  factory PickingThemeData.darkBlue() {
    const black = Color.fromARGB(190, 0, 0, 0);
    const darkBlue = Color.fromARGB(255, 2, 48, 71);
    const lightBlue = Color.fromARGB(255, 142, 202, 230);
    const red = Color.fromARGB(255, 250, 77, 77);
    const yellow = Color.fromARGB(255, 255, 183, 3);
    const white = Colors.white;
    return const PickingThemeData(
      backgroundColor: darkBlue,
      chartColor: lightBlue,
      metronomeBarColor: red,
      metronomeNoteColor: yellow,
      navigationColor: yellow,
      noteColor: lightBlue,
      noteLabelColor: black,
      textColor: white,
    );
  }

  TabContext tabContext() {
    return TabContext(
      chartColor: chartColor,
      labelColor: textColor,
      noteLabelColor: noteLabelColor,
      noteShapeColor: noteColor,
    );
  }
}

class PickingTheme extends InheritedWidget {
  final PickingThemeData theme;

  const PickingTheme({super.key, required super.child, required this.theme});

  static PickingThemeData of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<PickingTheme>();
    assert(result != null, 'No PickingTheme found in context');
    return result!.theme;
  }

  @override
  bool updateShouldNotify(PickingTheme oldWidget) {
    if (kDebugMode) {
      print('PickingTheme update from ${oldWidget.theme} to $theme');
    }
    return true;
  }
}

class ThemeStyledText extends StatelessWidget {
  final TextStyle? style;
  final String text;

  const ThemeStyledText(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    final theme = PickingTheme.of(context);
    return Text(text,
        style: style == null
            ? TextStyle(color: theme.textColor)
            : style!.copyWith(color: theme.textColor));
  }
}
