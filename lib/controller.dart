import 'package:flutter/foundation.dart';

class MetronomeConfig {
  final int bpm;

  MetronomeConfig({required this.bpm});
}

enum ProgressSkip { next, previous }

class ControllerEvent {
  final ProgressSkip? skip;
  final MetronomeConfig? metronome;

  ControllerEvent({this.skip, this.metronome});

  factory ControllerEvent.next() => ControllerEvent(skip: ProgressSkip.next);

  factory ControllerEvent.previous() =>
      ControllerEvent(skip: ProgressSkip.previous);
}

class PickingController extends ChangeNotifier
    implements ValueListenable<ControllerEvent?> {
  ControllerEvent event = ControllerEvent(skip: null, metronome: null);

  void next() {
    event = ControllerEvent.next();
    notifyListeners();
  }

  void previous() {
    event = ControllerEvent.previous();
    notifyListeners();
  }

  @override
  ControllerEvent? get value => event;
}
