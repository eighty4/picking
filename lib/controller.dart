import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class PickingController {
  final NavMenuController _navMenuController = NavMenuController();

  PickingController();

  void dispose() {
    _navMenuController.dispose();
  }

  NavMenuController get navMenu => _navMenuController;
}

class NavMenuController extends ChangeNotifier
    implements ValueListenable<bool> {
  bool open = false;

  void openMenu() {
    if (!open) {
      toggleMenu();
    }
  }

  void closeMenu() {
    if (open) {
      toggleMenu();
    }
  }

  void toggleMenu() {
    open = !open;
    notifyListeners();
  }

  @override
  bool get value => open;
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
