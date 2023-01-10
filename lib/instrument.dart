import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:picking/libtab/instrument.dart';

export 'package:picking/libtab/instrument.dart';

extension IconFn on Instrument {
  SvgPicture svg() {
    switch (this) {
      case Instrument.banjo:
        return SvgPicture.asset('assets/Banjo.svg', semanticsLabel: 'Banjo');
      case Instrument.guitar:
        return SvgPicture.asset('assets/Guitar.svg', semanticsLabel: 'Guitar');
    }
  }
}

extension OtherFn on Instrument {
  Instrument other() {
    return this == Instrument.banjo ? Instrument.guitar : Instrument.banjo;
  }
}

class InstrumentIcon extends StatelessWidget {
  final Instrument instrument;
  final double height;

  const InstrumentIcon(
    this.instrument, {
    super.key,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(dimension: height, child: instrument.svg());
  }
}

class CloudSvg extends SvgPicture {
  CloudSvg({super.key}) : super.asset('assets/Cloud.svg');
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
