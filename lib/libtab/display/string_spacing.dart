import 'package:flutter/widgets.dart';
import 'package:picking/libtab/libtab.dart';

class StringSpacing {
  final Instrument instrument;
  final double value;

  StringSpacing(this.instrument, this.value);

  factory StringSpacing.fromPaintSize(Instrument instrument, Size size) {
    return StringSpacing(instrument, calcValue(instrument, size));
  }

  static double calcValue(Instrument instrument, Size size) {
    return size.height / (instrument.stringCount() - 1);
  }

  double position(int string) {
    assert(string > 0);
    return value * (string - 1);
  }

  double sustainNotationPositionAbove(int string) {
    return position(string) - proportion(.3);
  }

  double sustainNotationPositionBelow(int string) {
    return position(string) + proportion(.3);
  }

  double proportion(double proportion) {
    return value * proportion;
  }
}
