import 'package:picking/libtab/instrument.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PickingAppData {
  static const String instrumentKey = 'picking.instrument';
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future<Instrument?> instrument() async {
    switch ((await _prefs).getString(instrumentKey)) {
      case 'banjo':
        return Instrument.banjo;
      case 'guitar':
        return Instrument.guitar;
    }
    return null;
  }

  static void saveInstrument(Instrument instrument) {
    _prefs.then((p) => p.setString(instrumentKey, instrument.name));
  }
}
