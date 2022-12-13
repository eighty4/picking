import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import "package:music_box/libtab/instrument.dart";

export "package:music_box/libtab/instrument.dart";

extension PathFn on Instrument {
  String path() {
    return '/${name()}';
  }
}

extension IconFn on Instrument {
  SvgPicture icon() {
    switch (this) {
      case Instrument.banjo:
        return banjoIcon;
      case Instrument.guitar:
        return guitarIcon;
    }
  }
}

extension OtherFn on Instrument {
  Instrument other() {
    return this == Instrument.banjo ? Instrument.guitar : Instrument.banjo;
  }
}

final banjoIcon =
    SvgPicture.asset("assets/banjo_nav.svg", semanticsLabel: "Banjo");
final guitarIcon =
    SvgPicture.asset("assets/guitar_nav.svg", semanticsLabel: "Guitar");

class InstrumentIcon extends StatelessWidget {
  final Instrument instrument;

  const InstrumentIcon(
    this.instrument, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: instrument.name(),
        child: SizedBox(child: instrument.icon(), height: 50, width: 50));
  }
}

class InstrumentModel extends InheritedWidget {
  final Instrument instrument;

  const InstrumentModel(
      {Key? key, required Widget child, required this.instrument})
      : super(key: key, child: child);

  static Instrument of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<InstrumentModel>();
    assert(result != null, "No InstrumentModel found in context");
    return result!.instrument;
  }

  @override
  bool updateShouldNotify(InstrumentModel oldWidget) {
    print("InstrumentModel update from ${oldWidget.instrument} to $instrument");
    return true;
  }
}
