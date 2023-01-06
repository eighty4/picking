import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

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

class PickingControllerModel extends InheritedWidget {
  final PickingController controller;

  const PickingControllerModel(
      {super.key, required super.child, required this.controller});

  static PickingController of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<PickingControllerModel>();
    assert(result != null, 'No PickingControllerModel found in context');
    return result!.controller;
  }

  @override
  bool updateShouldNotify(PickingControllerModel oldWidget) {
    if (kDebugMode) {
      print('PickingControllerModel update');
    }
    return true;
  }
}
