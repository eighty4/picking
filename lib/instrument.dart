import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:picking/libtab/instrument.dart';

export 'package:picking/libtab/instrument.dart';

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
    SvgPicture.asset('assets/banjo_nav.svg', semanticsLabel: 'Banjo');
final guitarIcon =
    SvgPicture.asset('assets/guitar_nav.svg', semanticsLabel: 'Guitar');

class InstrumentIcon extends StatelessWidget {
  final Instrument instrument;
  final Size size;

  const InstrumentIcon(
    this.instrument, {
    super.key,
    this.size = const Size(50, 50),
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: instrument.name(),
        child: SizedBox(
            height: size.height, width: size.width, child: instrument.icon()));
  }
}

class InstrumentModel extends InheritedWidget {
  final Instrument instrument;

  const InstrumentModel(
      {super.key, required super.child, required this.instrument});

  static Instrument of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<InstrumentModel>();
    assert(result != null, 'No InstrumentModel found in context');
    return result!.instrument;
  }

  @override
  bool updateShouldNotify(InstrumentModel oldWidget) {
    if (kDebugMode) {
      print(
          'InstrumentModel update from ${oldWidget.instrument} to $instrument');
    }
    return true;
  }
}
