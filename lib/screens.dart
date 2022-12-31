import 'package:flutter/material.dart';
import 'package:picking/libtab/libtab.dart';

import 'banjo.dart';
import 'controller.dart';
import 'ui.dart';

class PickingAppScreen extends StatelessWidget {
  final Widget child;
  final PickingController controller;

  const PickingAppScreen(
      {super.key, required this.child, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: UserInterface(controller: controller, child: child)));
  }
}

class PracticeScreen extends StatelessWidget {
  final PickingController pickingController;

  const PracticeScreen({super.key, required this.pickingController});

  @override
  Widget build(BuildContext context) {
    final tabContext =
        TabContext.forBrightness(MediaQuery.of(context).platformBrightness);
    return MeasureSwitcher.forMeasures(BanjoRolls.byLabel,
        pickingController: pickingController,
        instrument: Instrument.banjo,
        tabContext: tabContext);
  }
}

class MeasureSwitcher extends StatefulWidget {
  final List<WidgetBuilder> measureBuilders;
  final PickingController pickingController;

  const MeasureSwitcher(this.measureBuilders,
      {super.key, required this.pickingController});

  factory MeasureSwitcher.forMeasures(Map<String, Measure> measures,
      {required TabContext tabContext,
      required Instrument instrument,
      required PickingController pickingController}) {
    final measureBuilders = measures.entries
        .map((element) => (context) => MeasureDisplay(element.value,
            tabContext: tabContext,
            instrument: Instrument.banjo,
            label: element.key))
        .toList();
    return MeasureSwitcher(measureBuilders,
        pickingController: pickingController);
  }

  @override
  State<MeasureSwitcher> createState() => _MeasureSwitcherState();
}

class _MeasureSwitcherState extends State<MeasureSwitcher> {
  int i = 0;

  @override
  void initState() {
    super.initState();
    widget.pickingController.addListener(_onControllerEvent);
  }

  @override
  void dispose() {
    super.dispose();
    widget.pickingController.removeListener(_onControllerEvent);
  }

  _onControllerEvent() {
    if (widget.pickingController.event.skip != null) {
      switch (widget.pickingController.event.skip) {
        case ProgressSkip.next:
          _next();
          break;
        case ProgressSkip.previous:
          _prev();
          break;
        case null:
      }
    }
  }

  _next() {
    setState(() {
      if (i == widget.measureBuilders.length - 1) {
        i = 0;
      } else {
        i++;
      }
    });
  }

  _prev() {
    setState(() {
      if (i == 0) {
        i = widget.measureBuilders.length - 1;
      } else {
        i--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChartContainer([widget.measureBuilders[i](context)]);
  }
}

class ChartContainer extends StatelessWidget {
  final List<Widget> children;

  const ChartContainer(this.children, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: children));
  }
}

class ShowMeSomeTabs extends StatelessWidget {
  const ShowMeSomeTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final tabContext =
        TabContext.forBrightness(MediaQuery.of(context).platformBrightness);
    return ChartContainer([
      MeasureDisplay(BanjoRolls.forward,
          instrument: Instrument.banjo, tabContext: tabContext),
      ChordChartDisplay(
          size: const Size(100, 125),
          tabContext: tabContext,
          chord: BanjoChords.c),
    ]);
  }
}
