import 'package:flutter/widgets.dart';
import 'package:picking/libtab/libtab.dart';

class StringSpacing {
  final double value;

  StringSpacing(this.value);

  factory StringSpacing.fromPaintSize(Instrument instrument, Size size) {
    return StringSpacing(size.height  / (instrument.stringCount() - 1));
  }

  position(int string) {
    assert(string > 0);
    return value * (string - 1);
  }

  sustainNotationPositionAbove(int string) {
    return position(string) - proportion(.3);
  }

  sustainNotationPositionBelow(int string) {
    return position(string) + proportion(.3);
  }

  proportion(double proportion) {
    assert(proportion >= -1 && proportion <= 1);
    return value * proportion;
  }
}
