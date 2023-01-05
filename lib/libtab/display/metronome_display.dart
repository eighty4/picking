import 'dart:async';
import 'dart:core';

import 'package:flutter/widgets.dart';
import 'package:picking/libtab/libtab.dart';

class MetronomePosition {
  final double x;
  final Note note;

  MetronomePosition({required this.x, required this.note});

  factory MetronomePosition.calculateForNote(
      Note note, ChartPositioning chartPositioning, TabContext tabContext) {
    final x = chartPositioning.xPosition(note);
    return MetronomePosition(x: x, note: note);
  }
}

class Metronome extends StatefulWidget {
  final List<MetronomePosition> positions;
  final Size size;
  final TabContext tabContext;

  const Metronome(
      {super.key,
      required this.positions,
      required this.size,
      required this.tabContext});

  factory Metronome.forNotes(List<Note> notes,
      {required Size size,
      required ChartPositioning chartPositioning,
      required TabContext tabContext}) {
    final positions = notes
        .map((note) => MetronomePosition.calculateForNote(
            note, chartPositioning, tabContext))
        .toList();
    return Metronome(size: size, positions: positions, tabContext: tabContext);
  }

  @override
  State<Metronome> createState() => _MetronomeState();
}

class _MetronomeState extends State<Metronome> {
  Timer? timer;
  int i = -1;

  @override
  void initState() {
    super.initState();
    setTimer();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  void didUpdateWidget(Metronome oldWidget) {
    super.didUpdateWidget(oldWidget);
    timer?.cancel();
    setState(() => i = -1);
    setTimer();
  }

  void setTimer() {
    timer = Timer(const Duration(seconds: 1), timerCallback);
  }

  void timerCallback() {
    if (i < widget.positions.length - 1) {
      setState(() => i++);
    } else {
      setState(() => i = 0);
    }
    setTimer();
  }

  @override
  Widget build(BuildContext context) {
    final position = i == -1 ? null : widget.positions[i];
    return CustomPaint(
        size: widget.size,
        willChange: true,
        painter: MetronomePainter(
            position: position, tabContext: widget.tabContext));
  }
}

class MetronomePainter extends CustomPainter {
  final MetronomePosition? position;
  final TabContext tabContext;

  MetronomePainter({required this.position, required this.tabContext});

  @override
  void paint(Canvas canvas, Size size) {
    if (position == null) {
      return;
    }
    final path = Path()
      ..addRect(Rect.fromPoints(Offset(position!.x - 15, -18),
          Offset(position!.x + 15, size.height + 18)));
    canvas.drawPath(path, tabContext.metronomePaint(PaintingStyle.fill));
  }

  @override
  bool shouldRepaint(covariant MetronomePainter oldDelegate) =>
      position != oldDelegate.position;
}
