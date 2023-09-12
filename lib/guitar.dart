import 'package:flutter/material.dart';
// import 'package:libtab/libtab.dart';

import 'routing.dart';
import 'theme.dart';

class PlayGuitarStrums extends StatelessWidget {
  const PlayGuitarStrums({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(
            child: Text('Guitar features coming soon.',
                style: TextStyle(fontSize: 30))),
        const SizedBox(height: 60),
        MaterialButton(
            autofocus: true,
            onPressed: () {
              context.launch();
            },
            // todo can this be configured with a material app theme?
            color: PickingTheme.of(context).actionColor,
            child: const Text('Back to beginning')),
      ],
    );

    // final List<Note?> notes = [];
    // return Center(
    //   child: MeasureDisplay(
    //       Measure.fromNoteList(notes, repeatStart: true, repeatEnd: true),
    //       tabContext: PickingTheme.of(context).tabContext(),
    //       instrument: Instrument.guitar),
    // );
  }
}
