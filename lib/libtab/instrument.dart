enum Instrument {
  banjo,
  guitar,
}

extension NameFn on Instrument {
  String name() {
    switch (this) {
      case Instrument.banjo:
        return 'banjo';
      case Instrument.guitar:
        return 'guitar';
    }
  }
}

extension StringsFn on Instrument {
  int stringCount() {
    switch (this) {
      case Instrument.banjo:
        return 5;
      case Instrument.guitar:
        return 6;
    }
  }
}
