import 'package:flutter/material.dart';

import 'data.dart';
import 'instrument.dart';
import 'routing.dart';
import 'screen.dart';

class LaunchRoute extends StatefulWidget {
  const LaunchRoute({super.key});

  @override
  State<LaunchRoute> createState() => _LaunchRouteState();
}

class _LaunchRouteState extends State<LaunchRoute> {
  bool waiting = true;

  @override
  void initState() {
    super.initState();
    PickingAppData.launchData().then((launchData) {
      if (!mounted) {
        return;
      }
      if (launchData.instrument == null) {
        setState(() => waiting = false);
      } else {
        context.browseChords();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    late final Widget content;
    if (waiting) {
      content = const SizedBox(height: 3);
    } else {
      final size = MediaQuery.of(context).size;
      final instrumentHeight = MediaQuery.of(context).size.height * .4;
      content = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InstrumentSelection(Instrument.banjo, height: instrumentHeight),
            SizedBox(width: size.height * .1),
            InstrumentSelection(Instrument.guitar, height: instrumentHeight),
          ]);
    }
    return PickingScreen(child: content);
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
            child: SizedBox.square(dimension: widget.height, child: CloudSvg()),
          )),
      MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (event) => setState(() => focus = true),
          onExit: (event) => setState(() => focus = false),
          child: GestureDetector(
              onTap: () {
                PickingAppData.saveInstrument(widget.instrument);
                context.browseChords();
              },
              child: InstrumentIcon(widget.instrument, height: widget.height))),
    ]);
  }
}
