import 'dart:async';
import 'package:flutter/material.dart';

class TimerFlow extends StatefulWidget {
  final VoidCallback? onComplete;
  final List<WidgetBuilder> screens;
  final Duration screenDuration;

  const TimerFlow(
      {Key? key,
      this.onComplete,
      required this.screens,
      required this.screenDuration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TimerFlowState();
}

class _TimerFlowState extends State<TimerFlow> {
  int screen = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer(widget.screenDuration, handleTimeout);
  }

  void handleTimeout() {
    if (isComplete()) {
      if (widget.onComplete != null) {
        widget.onComplete!();
      }
    } else {
      setState(() {
        screen++;
      });
      startTimer();
    }
  }

  bool isComplete() {
    return screen >= widget.screens.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchOutCurve: Curves.easeOutQuint,
          switchInCurve: Curves.easeInQuint,
          child: buildCurrentWidget()),
      TimedProgressIndicator(duration: widget.screenDuration),
    ]);
  }

  Widget buildCurrentWidget() {
    return Center(key: UniqueKey(), child: widget.screens[screen](context));
  }
}

class TimedProgressIndicator extends StatefulWidget {
  final Duration duration;

  const TimedProgressIndicator({Key? key, required this.duration})
      : super(key: key);

  @override
  State<TimedProgressIndicator> createState() => _TimedProgressIndicatorState();
}

class _TimedProgressIndicatorState extends State<TimedProgressIndicator>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() {
        setState(() {});
      })
      ..forward();
  }

  @override
  void didUpdateWidget(TimedProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.forward(from: 0);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * .2, vertical: 50),
      child: LinearProgressIndicator(minHeight: 5, value: controller.value),
    );
  }
}
