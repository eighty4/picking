import 'package:flutter/material.dart';
import 'package:picking/banjo.dart';
import 'package:picking/guitar.dart';
import 'package:picking/instrument.dart';

class PlayMusic extends StatefulWidget {
  const PlayMusic({super.key});

  @override
  State<PlayMusic> createState() => _PlayMusicState();
}

class _PlayMusicState extends State<PlayMusic> {
  @override
  Widget build(BuildContext context) {
    final instrument = InstrumentModel.of(context);
    return switch (instrument) {
      Instrument.banjo => const PlayBanjoRolls(),
      Instrument.guitar => const PlayGuitarStrums(),
    };
  }
}
