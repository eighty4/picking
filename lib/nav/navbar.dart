import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../instrument.dart';
import 'instrument_swap.dart';

class Navbar extends StatelessWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InstrumentModel.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
      child: Row(children: const [
        InstrumentSwap(),
        NavbarTextLink("Play"),
        NavbarTextLink("Write"),
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
    return ButtonSwap(
      buttons: {
        InstrumentIcon(instrument): () => onInstrumentSwap(context, other),
        InstrumentIcon(other): () => onInstrumentSwap(context, instrument),
      },
      // size: const Size(50, 50),
    );
  }

  void onInstrumentSwap(BuildContext context, Instrument instrument) {
    Navigator.pushNamed(context, instrument.path());
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
