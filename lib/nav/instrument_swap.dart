import 'package:flutter/widgets.dart';

class ButtonSwap extends StatefulWidget {
  final Map<Widget, VoidCallback> buttons;

  const ButtonSwap({Key? key, required this.buttons}) : super(key: key);

  @override
  State<ButtonSwap> createState() => ButtonSwapState();
}

class ButtonSwapState extends State<ButtonSwap> {
  late Iterable<MapEntry<Widget, VoidCallback>> buttons;
  late int current;

  @override
  void initState() {
    buttons = widget.buttons.entries;
    current = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _createButton();
  }

  Widget _createButton() {
    final button = buttons.elementAt(current);
    return GestureDetector(child: button.key, onTap: _onTap);
  }

  void _onTap() {
    buttons.elementAt(current).value();
  }
}
