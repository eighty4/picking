import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libtab/libtab.dart';

import 'browse.dart';
import 'controller.dart';
import 'screen.dart';

class TechniquesMenuRoute extends StatelessWidget {
  const TechniquesMenuRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return PickingScreen(
        child: BrowsingGrid<Technique>(
      crossAxisCount: 3,
      controller: PickingController.of(context),
      itemBuilder: <Technique>(technique) => buildTechniqueGridItem(technique),
      items: Technique.values,
      onItemSelected: <Technique>(technique) => onItemSelected(technique),
    ));
  }

  onItemSelected(Technique technique) {
    if (kDebugMode) {
      print('$technique selected');
    }
  }

  Widget buildTechniqueGridItem(Technique technique) {
    return Center(
      child: switch (technique) {
        Technique.hammerOn => const Text('Hammer-on'),
        Technique.pullOff => const Text('Pull-ff'),
        Technique.slide => const Text('Slide'),
      },
    );
  }
}
