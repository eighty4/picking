import 'package:flutter/material.dart';
import 'package:picking/libtab/libtab.dart';

import 'practice.dart';

class IconSet {
  final IconData left;
  final IconData up;
  final IconData right;
  final IconData down;

  const IconSet(
      {required this.left,
      required this.up,
      required this.right,
      required this.down});
}

class IconSets {
  IconSets._();

  static const triangle = IconSet(
      left: Icons.arrow_left,
      up: Icons.arrow_drop_up,
      right: Icons.arrow_right,
      down: Icons.arrow_drop_down);

  static const active = triangle;
}

class TvApp extends StatelessWidget {
  const TvApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        body: Column(
          children: [
            TvControlsRow(padding: const EdgeInsets.only(top: 5), controls: [
              TvControl(icon: IconSets.triangle.up, text: 'navigate'),
            ]),
            const ShowMeSomeTabs(),
            TvControlsRow(padding: const EdgeInsets.only(bottom: 5), controls: [
              TvControl(icon: IconSets.triangle.left, text: 'back'),
              TvControl(icon: IconSets.triangle.down, text: 'metronome'),
              TvControl(icon: IconSets.triangle.right, text: 'forward'),
            ]),
          ],
        ),
      ),
    );
  }
}

class TvControlsRow extends StatelessWidget {
  final EdgeInsets padding;
  final List<TvControl> controls;

  const TvControlsRow({
    Key? key,
    required this.padding,
    required this.controls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: controls),
    );
  }
}

class TvControl extends StatelessWidget {
  final IconData icon;
  final String text;

  const TvControl({Key? key, required this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(text: '', children: [
        WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Icon(icon, size: 35)),
        TextSpan(text: ' $text', style: DefaultTextStyle.of(context).style)
      ]),
    );
  }
}

class ShowMeSomeTabs extends StatelessWidget {
  const ShowMeSomeTabs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      PracticeScreen(
          tabContext: TabContext.forBrightness(
              MediaQuery.of(context).platformBrightness),
          practice: BanjoRolls.forward)
    ]));
  }
}
