import 'package:flutter/widgets.dart';

class ButtonSwap extends StatefulWidget {
  final Widget primary;
  final Widget secondary;
  final Size size;
  late final Path path;

  ButtonSwap({
    Key? key,
    required this.primary,
    required this.secondary,
    required this.size,
  }) : super(key: key) {
    path = Path();
    path.moveTo(size.width, size.height);
    path.quadraticBezierTo(-size.width / 2, size.height * .8, size.width, 0);
  }

  @override
  ButtonSwapState createState() => ButtonSwapState();
}

class ButtonSwapState extends State<ButtonSwap> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.size.height,
        width: widget.size.width,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SwapAnimation(widget.primary, widget.path, initial: true),
            SwapAnimation(widget.secondary, widget.path),
          ],
        ));
  }
}

enum SwapDirection {
  up,
  down,
}

class SwapAnimation extends StatefulWidget {
  final bool initial;
  final Path path;
  final Widget child;

  const SwapAnimation(this.child, this.path, {Key? key, this.initial = false})
      : super(key: key);

  @override
  SwapAnimationState createState() => SwapAnimationState();
}

class SwapAnimationState extends State<SwapAnimation> {
  late SwapDirection dir;

  @override
  void initState() {
    super.initState();
    dir = widget.initial ? SwapDirection.up : SwapDirection.down;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.initial ? 0 : -50,
      child: GestureDetector(
        onTap: () {},
        child: widget.child,
      ),
    );
  }
}
