import 'package:flutter/material.dart';

import 'instrument.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SelectInstrumentScreen();
  }
}

class SelectInstrumentScreen extends StatelessWidget {
  const SelectInstrumentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: const [
      SelectInstrumentPic(Instrument.banjo, 0.225),
      SelectInstrumentPic(Instrument.guitar, 0.775),
    ]));
  }
}

class SelectInstrumentPic extends StatelessWidget {
  final Instrument instrument;
  final double xOffset;

  const SelectInstrumentPic(this.instrument, this.xOffset, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: FractionalOffset(xOffset, 0.4),
      child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, instrument.path());
          },
          child: InstrumentIcon(instrument, size: const Size(250, 250))),
    );
  }
}
