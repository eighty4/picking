import 'package:flutter/material.dart';
import 'package:picking/libtab/libtab.dart';

import 'routes.dart';

class ChordsRoute extends StatelessWidget {
  static WidgetBuilder builder = (context) => const ChordsRoute();

  const ChordsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.settings.arguments is ChordRouteArguments) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as ChordRouteArguments;
      return Expanded(
          child: Center(child: Text('chord ${arguments.chord.id()}')));
    } else if (ModalRoute.of(context)?.settings.arguments
        is ChordPairingRouteArguments) {
      final arguments = ModalRoute.of(context)?.settings.arguments
          as ChordPairingRouteArguments;
      if (arguments.path != null) {
        return Expanded(
            child: Center(
                child: Text(
                    'chords ${arguments.chord1.id()} and ${arguments.chord2.id()} ${arguments.path!.name}')));
      } else {
        return Expanded(
            child: Center(
                child: Text(
                    'chords ${arguments.chord1.id()} and ${arguments.chord2.id()}')));
      }
    } else {
      return const Expanded(child: Center(child: Text('chords')));
    }
  }
}
