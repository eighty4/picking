import 'package:flutter/material.dart';
import 'controller.dart';
import 'screens.dart';

class PickingPageRoute extends MaterialPageRoute {
  final PickingController pickingController;

  PickingPageRoute(
      {required this.pickingController,
      required super.builder,
      super.settings,
      super.fullscreenDialog,
      super.maintainState});

  @override
  Widget buildContent(BuildContext context) {
    return PickingAppScreen(
        controller: pickingController, child: builder(context));
  }
}
