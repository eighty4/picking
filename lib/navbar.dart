import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'instrument.dart';

class Navbar extends StatelessWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
      child: Row(children: const [
        InstrumentSwap(),
        Spacer(),
        NavbarIcon(Icons.equalizer_rounded),
        NavbarIcon(Icons.cast_rounded),
      ]),
    );
  }
}

class InstrumentSwap extends StatelessWidget {
  const InstrumentSwap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final instrument = InstrumentModel.of(context);
    final other = instrument.other();
    if (kDebugMode) {
      print('InstrumentSwap.build instrument=$instrument other=$other');
    }
    return ButtonSwap(buttons: {
      InstrumentIcon(instrument): () => onInstrumentSwap(context, other),
      InstrumentIcon(other): () => onInstrumentSwap(context, instrument),
    });
  }

  void onInstrumentSwap(BuildContext context, Instrument instrument) {
    Navigator.pushNamed(context, instrument.path());
  }
}

class NavbarTextLink extends StatelessWidget {
  final String text;
  final String route;

  const NavbarTextLink(this.text, this.route, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 35),
        child: GestureDetector(
          onTap: () {
            if (kDebugMode) {
              print('pushing route $route');
            }
            Navigator.of(context).pushNamed(route);
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Text(text,
                style: GoogleFonts.quicksand(
                    textStyle: const TextStyle(
                        color: Colors.transparent,
                        shadows: [
                          Shadow(
                              color: Color.fromARGB(255, 30, 32, 41),
                              offset: Offset(0, -2))
                        ],
                        decoration: TextDecoration.underline,
                        decorationColor: Color.fromARGB(255, 176, 225, 255),
                        decorationThickness: 3,
                        fontSize: 26,
                        fontWeight: FontWeight.bold))),
          ),
        ));
  }
}

class NavbarIcon extends StatelessWidget {
  final IconData icon;

  const NavbarIcon(this.icon, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 35),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Icon(
            icon,
            color: Colors.black,
            size: 26,
          ),
        ));
  }
}

class ButtonSwap extends StatefulWidget {
  final Map<Widget, VoidCallback> buttons;

  const ButtonSwap({Key? key, required this.buttons}) : super(key: key);

  @override
  State<ButtonSwap> createState() => ButtonSwapState();
}

class ButtonSwapState extends State<ButtonSwap> {
  late Iterable<MapEntry<Widget, VoidCallback>> buttons;
  late int current;

  @override
  void initState() {
    buttons = widget.buttons.entries;
    current = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _createButton();
  }

  Widget _createButton() {
    final button = buttons.elementAt(current);
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(onTap: _onTap, child: button.key));
  }

  void _onTap() {
    buttons.elementAt(current).value();
  }
}
