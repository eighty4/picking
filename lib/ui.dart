import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'controller.dart';
import 'instrument.dart';
import 'routing.dart';
import 'theme.dart';

class UserInterface extends StatefulWidget {
  static const Duration navMenuToggleDuration = Duration(milliseconds: 125);
  final PickingControllerApi controller;
  final Widget child;

  const UserInterface(
      {super.key, required this.child, required this.controller});

  @override
  State<UserInterface> createState() => _UserInterfaceState();
}

class _UserInterfaceState extends State<UserInterface> {
  bool navMenuOpen = false;

  @override
  void initState() {
    super.initState();
    widget.controller.navMenu.addListener(() {
      setState(() => navMenuOpen = widget.controller.navMenu.isOpen);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      AnimatedPositioned(
          duration: UserInterface.navMenuToggleDuration,
          top: navMenuOpen ? 0 : -1 * NavMenu.height,
          bottom: navMenuOpen ? -1 * NavMenu.height : 0,
          left: 0,
          right: 0,
          child: Column(children: [
            NavMenu(controller: widget.controller.navMenu),
            SizedBox.fromSize(
                size: MediaQuery.of(context).size, child: widget.child)
          ])),
    ]);
  }
}

extension NavSectionFns on NavSection {
  String label() => switch (this) {
        NavSection.chords => 'Chords',
        NavSection.techniques => 'Techniques',
        NavSection.songs => 'Songs',
      };
}

class NavMenu extends StatefulWidget {
  static const double height = 100;
  final NavMenuController controller;

  const NavMenu({super.key, required this.controller});

  @override
  State<NavMenu> createState() => _NavMenuState();
}

class _NavMenuState extends State<NavMenu> {
  final FocusScopeNode focusScopeNode = FocusScopeNode(
    debugLabel: 'navMenuFocusScopeNode',
  );
  final Map<NavSection, FocusNode> focusNodes = Map.fromEntries([
    MapEntry(
        NavSection.chords, FocusNode(debugLabel: 'navMenuFocusNodeChords')),
    MapEntry(NavSection.techniques,
        FocusNode(debugLabel: 'navMenuFocusNodeTechniques')),
    MapEntry(NavSection.songs, FocusNode(debugLabel: 'navMenuFocusNodeSongs')),
  ]);
  NavSection? focusedNavSection;
  NavSection? hoveredNavSection;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        if (widget.controller.isOpen) {
          NavSection? toFocus = focusedNavSection;
          toFocus ??= context.currentNavSection();
          final toFocusFocusNode = toFocus == null ? null : focusNodes[toFocus];
          focusScopeNode.requestFocus(toFocusFocusNode);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    focusScopeNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
        bindings: <LogicalKeySet, VoidCallback>{
          LogicalKeySet(LogicalKeyboardKey.arrowDown): () {
            PickingController.of(context).navMenu.close();
          },
          LogicalKeySet(LogicalKeyboardKey.enter): () {
            if (focusedNavSection != null) {
              nav(focusedNavSection!);
            }
            PickingController.of(context).navMenu.close();
          },
        },
        child: FocusScope(
          debugLabel: 'navMenuFocusScope',
          node: focusScopeNode,
          onFocusChange: (focused) {
            if (kDebugMode) {
              print('navMenuFocusScope $focused');
            }
          },
          child: SizedBox(
            height: NavMenu.height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: NavSection.values.map(buildMenuNavLink).toList(),
            ),
          ),
        ));
  }

  Widget buildMenuNavLink(NavSection navSection) {
    return Focus(
      focusNode: focusNodes[navSection],
      onFocusChange: (focused) {
        if (kDebugMode) {
          print('navMenuFocusNode${navSection.label()}');
        }
        if (focused) {
          setState(() => focusedNavSection = navSection);
        }
      },
      child: GestureDetector(
        onTap: () => nav(navSection),
        child: MouseRegion(
            onEnter: (e) => setState(() => hoveredNavSection = navSection),
            onExit: (e) => setState(() => hoveredNavSection = null),
            cursor: SystemMouseCursors.click,
            child: MenuNavLink(
                text: navSection.label(),
                focused: navSection == focusedNavSection)),
      ),
    );
  }

  void nav(NavSection navSection) {
    if (navSection == NavSection.chords) {
      context.browseChords();
    } else if (navSection == NavSection.techniques) {
      context.browseTechniques();
    } else if (navSection == NavSection.songs) {
      context.browseChords();
    }
  }
}

class SelectedInstrument extends StatelessWidget {
  const SelectedInstrument({super.key});

  @override
  Widget build(BuildContext context) {
    return const InstrumentIcon(Instrument.banjo, height: 80);
  }
}

class MenuNavLink extends StatelessWidget {
  static const EdgeInsets iconPadding =
      EdgeInsets.only(left: 9, right: 9, bottom: 1);
  static const EdgeInsets textPadding =
      EdgeInsets.only(left: 9, right: 9, bottom: 2);

  final IconData? icon;
  final String? text;
  final bool focused;

  const MenuNavLink({super.key, this.icon, this.text, required this.focused})
      : assert(icon != null || text != null);

  @override
  Widget build(BuildContext context) {
    final PickingThemeData theme = PickingTheme.of(context);
    final Widget child = text == null
        ? Icon(icon, size: 30, color: theme.textColor)
        : Text(text!, style: textStyle(theme.textColor));
    return Stack(children: [
      Container(
          height: 50,
          padding:
              text == null ? MenuNavLink.iconPadding : MenuNavLink.textPadding,
          decoration: BoxDecoration(
              border: Border.all(
                  color: focused ? theme.navigationColor : Colors.transparent,
                  width: 2),
              borderRadius: BorderRadius.circular(15)),
          child: Center(child: child)),
    ]);
  }

  TextStyle textStyle(Color color) {
    return TextStyle(color: color, fontSize: 30, fontWeight: FontWeight.w500);
  }
}
