import 'package:flutter/material.dart';

import 'instrument.dart';
import 'routes.dart';
import 'theme.dart';

class TopMenu extends StatefulWidget {
  static const double height = 100;

  const TopMenu({super.key});

  @override
  State<TopMenu> createState() => _TopMenuState();
}

class _TopMenuState extends State<TopMenu> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: TopMenu.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          MenuNavLink(text: 'Chords', path: PickingRoutes.chords),
          MenuNavLink(text: 'Techniques', path: PickingRoutes.techniques),
          MenuNavLink(text: 'Songs', path: PickingRoutes.songs),
          MenuNavLink(icon: Icons.settings, path: PickingRoutes.settings),
        ],
      ),
    );
  }
}

class SelectedInstrument extends StatelessWidget {
  const SelectedInstrument({super.key});

  @override
  Widget build(BuildContext context) {
    return const InstrumentIcon(Instrument.banjo, height: 80, width: 80);
  }
}

class MenuNavLink extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final String path;

  const MenuNavLink({super.key, this.icon, this.text, required this.path})
      : assert(icon != null || text != null);

  @override
  Widget build(BuildContext context) {
    final Color color = PickingTheme.of(context).textColor;
    final Widget child = text == null
        ? Icon(icon, size: 30, color: color)
        : Text(text!, style: textStyle(color));
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(path);
            },
            child: child));
  }

  TextStyle textStyle(Color color) {
    return TextStyle(color: color, fontSize: 30, fontWeight: FontWeight.w500);
  }
}
