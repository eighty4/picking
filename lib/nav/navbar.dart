import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../instrument.dart';
import 'instrument_swap.dart';

class Navbar extends StatelessWidget {
  final Instrument instrument;

  const Navbar(this.instrument, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
      child: Row(children: [
        ButtonSwap(
          primary: InstrumentIcon(instrument),
          secondary: InstrumentIcon(instrument.other()),
          size: const Size(50, 50),
        ),
        const NavbarTextLink("Play"),
        const NavbarTextLink("Write"),
        const Spacer(),
        const NavbarIcon(Icons.equalizer_rounded),
        const NavbarIcon(Icons.cast_rounded),
      ]),
    );
  }
}

class NavbarTextLink extends StatelessWidget {
  final String text;

  const NavbarTextLink(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 35),
        child: Text(text,
            style: GoogleFonts.quicksand(
                textStyle: const TextStyle(
                    fontSize: 26, fontWeight: FontWeight.bold))));
  }
}

class NavbarIcon extends StatelessWidget {
  final IconData icon;

  const NavbarIcon(this.icon, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 35),
        child: Icon(
          icon,
          color: Colors.black,
          size: 26,
        ));
  }
}
