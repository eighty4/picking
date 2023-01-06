import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'controller.dart';
import 'menu.dart';

class IconSet {
  final IconData left;
  final IconData up;
  final IconData right;
  final IconData down;

  const IconSet(
      {required this.left,
      required this.up,
      required this.right,
      required this.down});
}

class IconSets {
  IconSets._();

  static const triangle = IconSet(
      left: Icons.arrow_left,
      up: Icons.arrow_drop_up,
      right: Icons.arrow_right,
      down: Icons.arrow_drop_down);

  static const active = triangle;
}

class UserInterface extends StatefulWidget {
  final PickingController controller;
  final Widget child;

  const UserInterface(
      {super.key, required this.child, required this.controller});

  @override
  State<UserInterface> createState() => _UserInterfaceState();
}

class _UserInterfaceState extends State<UserInterface> {
  static const Duration duration = Duration(milliseconds: 125);

  ShiftingPosition? open;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.arrowUp): () {
          if (open == null) {
            _openTopMenu();
          } else if (open == ShiftingPosition.bottom) {
            _closeOpenMenu();
          }
        },
        const SingleActivator(LogicalKeyboardKey.arrowDown): () {
          if (open == null) {
            _openBottomMenu();
          } else if (open == ShiftingPosition.top) {
            _closeOpenMenu();
          } else if (open == ShiftingPosition.bottom) {
            // todo toggle metronome mode
          }
        },
        const SingleActivator(LogicalKeyboardKey.arrowRight): () {
          if (open == null) {
            widget.controller.next();
          } else if (open == ShiftingPosition.top) {
            // todo navigate menu
          } else if (open == ShiftingPosition.bottom) {
            // todo speed up metronome
          }
        },
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () {
          if (open == null) {
            widget.controller.previous();
          } else if (open == ShiftingPosition.top) {
            // todo navigate menu
          } else if (open == ShiftingPosition.bottom) {
            // todo slow down metronome
          }
        },
      },
      child: Focus(
        autofocus: true,
        child: Stack(children: [
          ShiftingMenuPositioned(
            duration: duration,
            menuHeight: TopMenu.height,
            open: open == ShiftingPosition.top,
            position: ShiftingPosition.top,
            windowHeight: height,
            child: const TopMenu(),
          ),
          ShiftingContentPositioned(
              duration: duration,
              topMenuHeight: TopMenu.height,
              bottomMenuHeight: BottomMenu.height,
              open: open,
              child: Column(
                children: [
                  TopControlsRow(
                      menuOpen: open == ShiftingPosition.top,
                      onOpenMenuTap: _openTopMenu,
                      onCloseMenuTap: _closeOpenMenu),
                  widget.child,
                  BottomControlsRow(
                      menuOpen: open == ShiftingPosition.bottom,
                      onOpenMenuTap: _openBottomMenu,
                      onCloseMenuTap: _closeOpenMenu),
                ],
              )),
          ShiftingMenuPositioned(
            duration: duration,
            menuHeight: BottomMenu.height,
            open: open == ShiftingPosition.bottom,
            position: ShiftingPosition.bottom,
            windowHeight: height,
            child: const BottomMenu(),
          ),
        ]),
      ),
    );
  }

  void _openTopMenu() {
    setState(() {
      open = ShiftingPosition.top;
    });
  }

  void _openBottomMenu() {
    setState(() {
      open = ShiftingPosition.bottom;
    });
  }

  void _closeOpenMenu() {
    setState(() {
      open = null;
    });
  }
}

enum ShiftingPosition { top, bottom }

class ShiftingContentPositioned extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double topMenuHeight;
  final double bottomMenuHeight;
  final ShiftingPosition? open;

  const ShiftingContentPositioned(
      {super.key,
      required this.duration,
      required this.topMenuHeight,
      required this.bottomMenuHeight,
      required this.open,
      required this.child});

  @override
  Widget build(BuildContext context) {
    if (open == null) {
      return AnimatedPositioned(
        duration: duration,
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        child: child,
      );
    } else {
      return AnimatedPositioned(
        duration: duration,
        top: open == ShiftingPosition.bottom
            ? -1 * bottomMenuHeight
            : topMenuHeight,
        bottom: open == ShiftingPosition.top
            ? -1 * topMenuHeight
            : bottomMenuHeight,
        left: 0,
        right: 0,
        child: child,
      );
    }
  }
}

class ShiftingMenuPositioned extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double menuHeight;
  final bool open;
  final ShiftingPosition position;
  final double windowHeight;

  const ShiftingMenuPositioned(
      {super.key,
      required this.child,
      required this.duration,
      required this.menuHeight,
      required this.open,
      required this.position,
      required this.windowHeight});

  @override
  Widget build(BuildContext context) {
    switch (position) {
      case ShiftingPosition.top:
        return AnimatedPositioned(
            duration: duration,
            top: open ? 0 : -1 * menuHeight,
            left: 0,
            right: 0,
            child: SizedBox(height: menuHeight, child: child));
      case ShiftingPosition.bottom:
        return AnimatedPositioned(
            duration: duration,
            bottom: open ? 0 : -1 * menuHeight,
            left: 0,
            right: 0,
            child: SizedBox(height: menuHeight, child: child));
    }
  }
}

class BottomMenu extends StatefulWidget {
  static const double height = 50;

  const BottomMenu({super.key});

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        Text('more'),
        Text('menu'),
        Text('content'),
      ],
    );
  }
}

class TvControlsRow extends StatelessWidget {
  final EdgeInsets padding;
  final List<TvControl> controls;

  const TvControlsRow({
    super.key,
    required this.padding,
    required this.controls,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: controls),
    );
  }
}

class TvControl extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String text;

  const TvControl(
      {super.key, required this.icon, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: RichText(
          text: TextSpan(text: '', children: [
            WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(icon, size: 35)),
            TextSpan(text: ' $text', style: DefaultTextStyle.of(context).style)
          ]),
        ),
      ),
    );
  }
}

class TopControlsRow extends StatelessWidget {
  static const Key openKey = Key('top-menu-open');
  static const Key closedKey = Key('top-menu-closed');
  final bool menuOpen;
  final VoidCallback onOpenMenuTap;
  final VoidCallback onCloseMenuTap;

  const TopControlsRow(
      {super.key,
      required this.menuOpen,
      required this.onOpenMenuTap,
      required this.onCloseMenuTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 125),
      child: menuOpen ? _buildMenuOpen() : _buildMenuClosed(),
    );
  }

  TvControlsRow _buildMenuClosed() {
    return TvControlsRow(
        key: closedKey,
        padding: const EdgeInsets.only(top: 5),
        controls: [
          TvControl(
              icon: IconSets.triangle.up, text: 'menu', onTap: onOpenMenuTap),
        ]);
  }

  TvControlsRow _buildMenuOpen() {
    return TvControlsRow(
        key: openKey,
        padding: const EdgeInsets.only(top: 5),
        controls: [
          TvControl(
              icon: IconSets.triangle.down,
              text: 'close',
              onTap: onCloseMenuTap),
        ]);
  }
}

class BottomControlsRow extends StatelessWidget {
  static const Key openKey = Key('bottom-menu-open');
  static const Key closedKey = Key('bottom-menu-closed');
  final bool menuOpen;
  final VoidCallback onOpenMenuTap;
  final VoidCallback onCloseMenuTap;

  const BottomControlsRow(
      {super.key,
      required this.menuOpen,
      required this.onOpenMenuTap,
      required this.onCloseMenuTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 125),
      child: menuOpen ? _buildMenuOpen() : _buildMenuClosed(),
    );
  }

  TvControlsRow _buildMenuClosed() {
    return TvControlsRow(
        key: closedKey,
        padding: const EdgeInsets.only(bottom: 5),
        controls: [
          TvControl(icon: IconSets.triangle.left, text: 'back', onTap: () {}),
          TvControl(
              icon: IconSets.triangle.down,
              text: 'metronome',
              onTap: onOpenMenuTap),
          TvControl(
              icon: IconSets.triangle.right, text: 'forward', onTap: () {}),
        ]);
  }

  TvControlsRow _buildMenuOpen() {
    return TvControlsRow(
        key: openKey,
        padding: const EdgeInsets.only(bottom: 5),
        controls: [
          TvControl(
              icon: IconSets.triangle.up, text: 'close', onTap: onCloseMenuTap),
        ]);
  }
}
