import 'package:flutter/material.dart';

import 'data.dart';
import 'instrument.dart';
import 'routes.dart';

class LaunchRoute extends StatefulWidget {
  static WidgetBuilder builder = (context) => const LaunchRoute();

  const LaunchRoute({super.key});

  @override
  State<LaunchRoute> createState() => _LaunchRouteState();
}

class _LaunchRouteState extends State<LaunchRoute> {
  bool waiting = true;

  @override
  void initState() {
    super.initState();
    PickingAppData.instrument().then((instrument) {
      if (mounted) {
        if (instrument == null) {
          setState(() => waiting = false);
        } else {
          Navigator.of(context).pushNamed(PickingRoutes.chords);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (waiting) {
      return const SizedBox(height: 3);
    } else {
      final size = MediaQuery.of(context).size;
      final instrumentHeight = MediaQuery.of(context).size.height * .4;
      return Expanded(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InstrumentSelection(Instrument.banjo, height: instrumentHeight),
              SizedBox(width: size.height * .1),
              InstrumentSelection(Instrument.guitar, height: instrumentHeight),
            ]),
      );
    }
  }
}

class InstrumentSelection extends StatefulWidget {
  final Instrument instrument;
  final double height;

  const InstrumentSelection(this.instrument, {super.key, required this.height});

  @override
  State<InstrumentSelection> createState() => _InstrumentSelectionState();
}

class _InstrumentSelectionState extends State<InstrumentSelection> {
  bool focus = false;

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: focus ? 1 : 0,
          child: AnimatedScale(
            curve: Curves.decelerate,
            scale: focus ? 1.1 : 0,
            duration: const Duration(milliseconds: 150),
            child: SizedBox.square(
                dimension: widget.height, child: CloudSvg()),
          )),
      MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (event) => setState(() => focus = true),
          onExit: (event) => setState(() => focus = false),
          child: GestureDetector(
              onTap: () {
                PickingAppData.saveInstrument(widget.instrument);
                Navigator.of(context).pushNamed(PickingRoutes.chords);
              },
              child: InstrumentIcon(widget.instrument, height: widget.height))),
    ]);
  }
}
