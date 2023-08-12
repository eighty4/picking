import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'controller.dart';

typedef BuilderFn<T> = Widget Function(T);

typedef ItemSelectedFn<T> = void Function(T);

class BrowsingGrid<T> extends StatefulWidget {
  final PickingControllerApi controller;
  final int crossAxisCount;
  final BuilderFn<T> itemBuilder;
  final List<T> items;
  final ItemSelectedFn onItemSelected;

  const BrowsingGrid(
      {super.key,
      required this.itemBuilder,
      required this.items,
      required this.controller,
      required this.crossAxisCount,
      required this.onItemSelected});

  @override
  State<BrowsingGrid> createState() => _BrowsingGridState();
}

class _BrowsingGridState extends State<BrowsingGrid> {
  final FocusScopeNode focusScopeNode =
      FocusScopeNode(debugLabel: 'gridFocusScopeNode');
  late final List<FocusNode> focusNodes;
  int focusedIndex = -1;
  int previousFocusedIndex = -1;

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(
        widget.items.length, (i) => FocusNode(debugLabel: 'gridFocusNode$i'));
    widget.controller.navMenu.addListener(onNavMenuOpenOrClose);
  }

  void onNavMenuOpenOrClose() {
    if (!widget.controller.navMenu.isOpen) {
      if (previousFocusedIndex == -1) {
        focusScopeNode.requestFocus();
      } else {
        focusNodes[previousFocusedIndex].requestFocus();
      }
    }
  }

  @override
  void dispose() {
    for (final focusNode in focusNodes) {
      focusNode.dispose();
    }
    widget.controller.navMenu.removeListener(onNavMenuOpenOrClose);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: <LogicalKeySet, VoidCallback>{
        LogicalKeySet(LogicalKeyboardKey.enter): selectFocusedItem,
      },
      child: FocusScope(
        debugLabel: 'gridFocusScope',
        node: focusScopeNode,
        autofocus: true,
        onFocusChange: (focused) {
          if (kDebugMode) {
            print('gridFocusScope $focused');
          }
        },
        child: Column(
          children: [
            Focus(
                debugLabel: 'gridFocusOpenMenu',
                onFocusChange: (focused) {
                  if (kDebugMode) {
                    print(
                        'gridFocusOpenMenu focused=$focused focusedIndex=$focusedIndex previousFocusedIndex=$previousFocusedIndex');
                  }
                  if (focused) {
                    if (focusedIndex != -1) {
                      PickingController.of(context).navMenu.open();
                      unsetFocus();
                    }
                  }
                },
                child: const SizedBox.shrink()),
            GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(50),
                itemCount: widget.items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.crossAxisCount,
                ),
                itemBuilder: (context, i) {
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (event) => setFocusOnHover(i),
                    child: GestureDetector(
                      onTap: selectFocusedItem,
                      child: Focus(
                        autofocus: i == 0,
                        debugLabel: 'gridFocus$i',
                        focusNode: focusNodes[i],
                        onFocusChange: (focused) {
                          if (focused) {
                            if (kDebugMode) {
                              print(
                                  'gridFocus$i focused=$focused focusedIndex=$focusedIndex previousFocusedIndex=$previousFocusedIndex');
                            }
                            setFocus(i);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: focusNodes[i].hasFocus
                                      ? Colors.red
                                      : Colors.transparent)),
                          child: widget.itemBuilder(widget.items[i]),
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  setFocus(int i) => setState(() => focusedIndex = previousFocusedIndex = i);

  unsetFocus() => setState(() => focusedIndex = -1);

  setFocusOnHover(int i) {
    focusNodes[i].requestFocus();
  }

  selectFocusedItem() {
    for (int i = 0; i < focusNodes.length; i++) {
      if (focusNodes[i].hasFocus) {
        widget.onItemSelected(widget.items[i]);
      }
    }
  }
}
