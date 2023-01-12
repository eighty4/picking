import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'controller.dart';
import 'menu.dart';
import 'theme.dart';

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
          // todo perf improvement could be one AnimatedPositioned with overflow
          ShiftingPositioned(
              open: open,
              child: Column(
                children: [
                  TopControlsRow(
                      menuOpen: open == ShiftingPosition.top,
                      onOpenMenuTap: _openTopMenu,
                      onCloseMenuTap: _closeOpenMenu),
                  Expanded(child: widget.child),
                  BottomControlsRow(
                      menuOpen: open == ShiftingPosition.bottom,
                      onOpenMenuTap: _openBottomMenu,
                      onCloseMenuTap: _closeOpenMenu),
                ],
              )),
          AnimatedPositioned(
              duration: duration,
              top: open == ShiftingPosition.top ? 0 : -1 * TopMenu.height,
              left: 0,
              right: 0,
              child: const TopMenu()),
          AnimatedPositioned(
              duration: duration,
              bottom:
                  open == ShiftingPosition.bottom ? 0 : -1 * BottomMenu.height,
              left: 0,
              right: 0,
              child: const BottomMenu()),
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

class ShiftingPositioned extends StatelessWidget {
  static const Duration duration = Duration(milliseconds: 125);
  final Widget child;
  final ShiftingPosition? open;

  const ShiftingPositioned(
      {super.key, required this.open, required this.child});

  @override
  Widget build(BuildContext context) {
    switch (open) {
      case ShiftingPosition.top:
        return AnimatedPositioned(
          duration: duration,
          top: TopMenu.height,
          bottom: -1 * TopMenu.height,
          left: 0,
          right: 0,
          child: child,
        );
      case ShiftingPosition.bottom:
        return AnimatedPositioned(
          duration: duration,
          top: -1 * BottomMenu.height,
          bottom: BottomMenu.height,
          left: 0,
          right: 0,
          child: child,
        );
      case null:
        return AnimatedPositioned(
          duration: duration,
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: child,
        );
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
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: BottomMenu.height,
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          ThemeStyledText('more'),
          ThemeStyledText('menu'),
          ThemeStyledText('content'),
        ],
      ),
    );
  }
}

class NavigationControlRow extends StatelessWidget {
  final EdgeInsets padding;
  final List<NavigationControl> controls;

  const NavigationControlRow({
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

class NavigationControl extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String text;

  const NavigationControl(
      {super.key, required this.icon, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = PickingTheme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: RichText(
          text: TextSpan(text: '', children: [
            WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(icon,
                    size: 45,
                    color: theme.navigationColor,
                    shadows: [
                      Shadow(
                          color: theme.noteLabelColor,
                          offset: const Offset(0, 1),
                          blurRadius: 1)
                    ])),
            TextSpan(
                text: ' $text',
                style: DefaultTextStyle.of(context)
                    .style
                    .copyWith(color: theme.textColor))
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

  NavigationControlRow _buildMenuClosed() {
    return NavigationControlRow(
        key: closedKey,
        padding: const EdgeInsets.only(top: 5),
        controls: [
          NavigationControl(
              icon: Icons.arrow_drop_up, text: 'menu', onTap: onOpenMenuTap),
        ]);
  }

  NavigationControlRow _buildMenuOpen() {
    return NavigationControlRow(
        key: openKey,
        padding: const EdgeInsets.only(top: 5),
        controls: [
          NavigationControl(
              icon: Icons.arrow_drop_down,
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

  NavigationControlRow _buildMenuClosed() {
    return NavigationControlRow(
        key: closedKey,
        padding: const EdgeInsets.only(bottom: 5),
        controls: [
          NavigationControl(icon: Icons.arrow_left, text: 'back', onTap: () {}),
          NavigationControl(
              icon: Icons.arrow_drop_down,
              text: 'metronome',
              onTap: onOpenMenuTap),
          NavigationControl(
              icon: Icons.arrow_right, text: 'forward', onTap: () {}),
        ]);
  }

  NavigationControlRow _buildMenuOpen() {
    return NavigationControlRow(
        key: openKey,
        padding: const EdgeInsets.only(bottom: 5),
        controls: [
          NavigationControl(
              icon: Icons.arrow_drop_up, text: 'close', onTap: onCloseMenuTap),
        ]);
  }
}
