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

class MenuNavLink extends StatefulWidget {
  static const EdgeInsets iconPadding =
      EdgeInsets.only(left: 9, right: 9, bottom: 1);
  static const EdgeInsets textPadding =
      EdgeInsets.only(left: 9, right: 9, bottom: 2);

  final IconData? icon;
  final String? text;
  final String path;

  const MenuNavLink({super.key, this.icon, this.text, required this.path})
      : assert(icon != null || text != null);

  @override
  State<MenuNavLink> createState() => _MenuNavLinkState();
}

class _MenuNavLinkState extends State<MenuNavLink> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    final PickingThemeData theme = PickingTheme.of(context);
    final Widget child = widget.text == null
        ? Icon(widget.icon, size: 30, color: theme.textColor)
        : Text(widget.text!, style: textStyle(theme.textColor));
    return Stack(children: [
      MouseRegion(
          onEnter: (event) => setState(() => hover = true),
          onExit: (event) => setState(() => hover = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(widget.path);
              },
              child: Container(
                  height: 50,
                  padding: widget.text == null
                      ? MenuNavLink.iconPadding
                      : MenuNavLink.textPadding,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: hover
                              ? theme.navigationColor
                              : Colors.transparent,
                          width: 2),
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(child: child)))),
    ]);
  }

  TextStyle textStyle(Color color) {
    return TextStyle(color: color, fontSize: 30, fontWeight: FontWeight.w500);
  }
}
