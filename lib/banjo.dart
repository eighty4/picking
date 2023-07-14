import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libtab/libtab.dart';

import 'screen.dart';
import 'theme.dart';

class PlayBanjoRolls extends StatefulWidget {
  static final Map<String, Measure> banjoRolls = {
    'Forward Roll': BanjoRolls.forward,
    'Backward Roll': BanjoRolls.backward,
    'Forward Backward Roll': BanjoRolls.forwardBackward,
    'Alternating Thumb Roll': BanjoRolls.alternatingThumb,
  };

  static final banjoRollLabels = banjoRolls.keys.toList(growable: false);

  const PlayBanjoRolls({super.key});

  @override
  State<PlayBanjoRolls> createState() => _PlayBanjoRollsState();
}

class _PlayBanjoRollsState extends State<PlayBanjoRolls>
    with SingleTickerProviderStateMixin {
  static const Duration duration = Duration(minutes: 2);
  static const Size size = Size(400, 200);
  int currentRoll = 0;
  late AnimationController controller;
  late Animation<double> animation;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: duration);
    animation = Tween<double>(begin: 0, end: size.width).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    setTimer();
  }

  @override
  void dispose() {
    controller.dispose();
    timer.cancel();
    super.dispose();
  }

  setTimer() {
    timer = Timer(duration, next);
    controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final tabContext = PickingTheme.of(context).tabContext();
    final label = PlayBanjoRolls.banjoRollLabels[currentRoll];
    final measure = PlayBanjoRolls.banjoRolls[label]!;
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        LogicalKeySet(LogicalKeyboardKey.arrowLeft): prev,
        LogicalKeySet(LogicalKeyboardKey.arrowRight): next,
      },
      child: Focus(
        autofocus: true,
        child: PickingScreen(
            child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MeasureDisplay(measure,
                  size: size,
                  tabContext: tabContext,
                  instrument: Instrument.banjo,
                  label: label),
              const SizedBox(height: 80),
              Stack(children: [
                Opacity(
                  opacity: .1,
                  child: Container(
                      height: 5,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: tabContext.chartColor,
                        borderRadius: BorderRadius.circular(2),
                      )),
                ),
                Container(
                    height: 5,
                    width: animation.value,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(2),
                    )),
              ]),
              const SizedBox(height: 20),
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.arrow_left, size: 50),
                Text('prev'),
                SizedBox(width: 50),
                Text('next'),
                Icon(Icons.arrow_right, size: 50),
              ]),
            ],
          ),
        )),
      ),
    );
  }

  next() {
    if (mounted) {
      setState(() {
        currentRoll = currentRoll == PlayBanjoRolls.banjoRolls.length - 1
            ? 0
            : currentRoll + 1;
      });
      resetTimer();
    }
  }

  prev() {
    if (mounted) {
      setState(() {
        currentRoll = currentRoll == 0
            ? PlayBanjoRolls.banjoRolls.length - 1
            : currentRoll - 1;
      });
      resetTimer();
    }
  }

  resetTimer() {
    timer.cancel();
    setTimer();
  }
}

class BanjoRolls {
  static final Measure forward = Measure.fromNoteList([
    Note(2, 0),
    Note(1, 0),
    Note(5, 0),
    Note(2, 0),
    Note(1, 0),
    Note(5, 0),
    Note(2, 0),
    Note(1, 0),
  ]);

  static final Measure backward = Measure.fromNoteList([
    Note(1, 0),
    Note(2, 0),
    Note(5, 0),
    Note(1, 0),
    Note(2, 0),
    Note(5, 0),
    Note(1, 0),
    Note(2, 0)
  ]);

  static final Measure forwardBackward = Measure.fromNoteList([
    Note(3, 0),
    Note(2, 0),
    Note(1, 0),
    Note(5, 0),
    Note(1, 0),
    Note(2, 0),
    Note(3, 0),
    Note(1, 0),
  ]);

  static final Measure alternatingThumb = Measure.fromNoteList([
    Note(3, 0),
    Note(2, 0),
    Note(5, 0),
    Note(1, 0),
    Note(4, 0),
    Note(2, 0),
    Note(5, 0),
    Note(1, 0),
  ]);
}

class BanjoTechniques {
  static final Map<String, Measure> byLabel = {
    'Hammer-on': hammerOn,
    'Pull-off': pullOff,
    'Slide': slideTo,
  };

  static final Measure hammerOn = Measure.fromNoteList([
    Note(3, 2, hammerOn: 3),
    null,
    Note(1, 0),
    Note(4, 0, hammerOn: 2, length: const Timing(NoteType.eighth, 2)),
    null,
    null,
    null,
    Note(1, 0),
  ]);

  static final Measure pullOff = Measure.fromNoteList([
    Note(3, 3, pullOff: 2),
    null,
    Note(1, 0),
    Note(4, 2, pullOff: 0, length: const Timing(NoteType.eighth, 2)),
    null,
    null,
    null,
    Note(1, 0),
  ]);

  static final Measure slideTo = Measure.fromNoteList([
    Note(3, 2, slideTo: 4),
    null,
    Note(2, 0),
    Note(1, 0),
    Note(4, 0, slideTo: 2, length: const Timing(NoteType.eighth, 2)),
    null,
    null,
    Note(1, 0),
  ]);
}
