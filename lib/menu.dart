import 'package:flutter/material.dart';

import 'instrument.dart';
import 'routes.dart';

class TopMenu extends StatefulWidget {
  static const double height = 100;

  const TopMenu({super.key});

  @override
  State<TopMenu> createState() => _TopMenuState();
}

class _TopMenuState extends State<TopMenu> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        MenuNavLink(text: 'Chords', path: PickingRoutes.chords),
        MenuNavLink(text: 'Techniques', path: PickingRoutes.techniques),
        MenuNavLink(text: 'Songs', path: PickingRoutes.songs),
        MenuNavLink(text: 'Settings', path: PickingRoutes.settings),
      ],
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
  final String text;
  final String path;

  const MenuNavLink({super.key, required this.text, required this.path});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(path);
            },
            child: Text(text)));
  }
}
