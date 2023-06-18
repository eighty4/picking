import 'package:libtab/instrument.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PickingLaunchData {
  final Instrument? instrument;

  PickingLaunchData(this.instrument);
}

class PickingAppData {
  static const String instrumentKey = 'picking.instrument';
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future<PickingLaunchData> launchData() async {
    final fetchingInstrument = PickingAppData.instrument();
    final instrument = await fetchingInstrument;
    return PickingLaunchData(instrument);
  }

  static Future<Instrument?> instrument() async {
    final instrument = (await _prefs).getString(instrumentKey);
    if (instrument == null) {
      return null;
    } else {
      return Instrument.values.byName(instrument);
    }
  }

  static void saveInstrument(Instrument instrument) {
    _prefs.then((p) => p.setString(instrumentKey, instrument.name));
  }
}
