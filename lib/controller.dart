import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class PickingControllerApi {
  final NavMenuController _navMenuController = NavMenuController();

  PickingControllerApi();

  void dispose() {
    _navMenuController.dispose();
  }

  NavMenuController get navMenu => _navMenuController;
}

class NavMenuController extends ChangeNotifier
    implements ValueListenable<bool> {
  bool _open = false;

  void open() {
    if (kDebugMode) {
      print('NavMenuController.open');
    }
    _open = true;
    notifyListeners();
  }

  void close() {
    if (kDebugMode) {
      print('NavMenuController.close');
    }
    _open = false;
    notifyListeners();
  }

  @override
  bool get value => _open;

  bool get isOpen => _open;
}

class PickingController extends InheritedWidget {
  final PickingControllerApi controller;

  const PickingController(
      {super.key, required super.child, required this.controller});

  static PickingControllerApi of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<PickingController>();
    assert(result != null, 'No PickingController found in context');
    return result!.controller;
  }

  @override
  bool updateShouldNotify(PickingController oldWidget) {
    return false;
  }
}
