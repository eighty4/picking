import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picking/data.dart';
import 'package:picking/instrument.dart';
import 'package:picking/routing.dart';
import 'package:picking/screen.dart';

class LaunchRoute extends StatefulWidget {
  const LaunchRoute({super.key});

  @override
  State<LaunchRoute> createState() => _LaunchRouteState();
}

class _LaunchRouteState extends State<LaunchRoute> {
  bool waiting = true;
  Instrument? instrument;

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
      const textStyle = TextStyle(fontSize: 26);
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
              "Pickin' is a companion app for beginning bluegrass players.",
              style: textStyle),
          const SizedBox(height: 20),
          const Text('Choose an instrument to get started.', style: textStyle),
          const SizedBox(height: 60),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InstrumentSelection(Instrument.banjo,
                    focused: instrument == Instrument.banjo,
                    height: instrumentHeight,
                    onHover: focusBanjo,
                    onTap: selectInstrument),
                SizedBox(width: size.height * .1),
                InstrumentSelection(Instrument.guitar,
                    focused: instrument == Instrument.guitar,
                    height: instrumentHeight,
                    onHover: focusGuitar,
                    onTap: selectInstrument),
              ]),
        ],
      );
    }
    return PickingScreen(
        child: CallbackShortcuts(bindings: <LogicalKeySet, VoidCallback>{
      LogicalKeySet(LogicalKeyboardKey.arrowLeft): focusBanjo,
      LogicalKeySet(LogicalKeyboardKey.arrowRight): focusGuitar,
      LogicalKeySet(LogicalKeyboardKey.enter): selectInstrument,
    }, child: Focus(autofocus: true, child: content)));
  }

  focusBanjo() {
    setState(() {
      instrument = Instrument.banjo;
    });
  }

  focusGuitar() {
    setState(() {
      instrument = Instrument.guitar;
    });
  }

  selectInstrument() {
    if (instrument != null) {
      PickingAppData.saveInstrument(instrument!);
      context.playMusic();
    }
  }
}

class InstrumentSelection extends StatelessWidget {
  final Instrument instrument;
  final double height;
  final bool focused;
  final VoidCallback onHover;
  final VoidCallback onTap;

  const InstrumentSelection(this.instrument,
      {super.key,
      required this.height,
      required this.focused,
      required this.onHover,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: focused ? 1 : 0,
          child: AnimatedScale(
            curve: Curves.decelerate,
            scale: focused ? 1.1 : 0,
            duration: const Duration(milliseconds: 150),
            child: SizedBox.square(dimension: height, child: CloudSvg()),
          )),
      MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (event) => onHover(),
          child: GestureDetector(
              onTap: onTap, child: InstrumentIcon(instrument, height: height))),
    ]);
  }
}
