import 'package:flutter_svg/flutter_svg.dart';

enum Instrument {
  banjo,
  guitar,
}

extension NameFn on Instrument {
  String name() {
    switch (this) {
      case Instrument.banjo:
        return "banjo";
      case Instrument.guitar:
        return "guitar";
    }
  }
}

extension PathFn on Instrument {
  String path() {
    return '/' + name();
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

final banjoIcon =
    SvgPicture.asset("assets/banjo_nav.svg", semanticsLabel: "Banjo");
final guitarIcon =
    SvgPicture.asset("assets/guitar_nav.svg", semanticsLabel: "Guitar");
