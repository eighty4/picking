import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:picking/libtab/libtab.dart';

import 'instrument.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final instrument = InstrumentModel.of(context);
    if (kDebugMode) print('$instrument tabs');
    return Container(
        padding: const EdgeInsets.all(150),
        child: MeasureDisplay(
            Measure([
              Note(0, 12),
              null,
              Note(3, 11),
              Note(3, 11),
              Note(1, 12, and: Note(2, 10)),
              null,
              Note(1, 14, and: Note(2, 14))
            ]),
            instrument: instrument,
            last: true));
  }
}
