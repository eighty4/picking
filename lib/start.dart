import 'package:flutter/material.dart';

import 'instrument.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StartScreenState();
  }
}

class StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return const SelectInstrumentScreen();
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
      child: Hero(
          tag: instrument.name(),
          child: GestureDetector(
              child: Container(
                  height: 250,
                  width: 250,
                  color: Colors.transparent,
                  child: instrument.icon()),
              onTap: () {
                Navigator.pushNamed(context, instrument.path());
              })),
    );
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
