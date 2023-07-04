import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:libtab/instrument.dart';

import 'data.dart';
import 'routing.dart';

export 'package:libtab/instrument.dart';

extension IconFn on Instrument {
  SvgPicture svg() {
    return switch (this) {
      Instrument.banjo =>
        SvgPicture.asset('assets/Banjo.svg', semanticsLabel: 'Banjo'),
      Instrument.guitar =>
        SvgPicture.asset('assets/Guitar.svg', semanticsLabel: 'Guitar'),
    };
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
    return oldWidget.instrument != instrument;
  }
}

class InitializeInstrumentModel extends StatefulWidget {
  final Widget child;

  const InitializeInstrumentModel({super.key, required this.child});

  @override
  State<InitializeInstrumentModel> createState() =>
      _InitializeInstrumentModelState();
}

class _InitializeInstrumentModelState extends State<InitializeInstrumentModel> {
  Instrument? instrument;

  @override
  void initState() {
    super.initState();
    PickingAppData.instrument().then((value) {
      if (value == null) {
        context.go(PickingRoutes.launch);
      } else {
        setState(() {
          instrument = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (instrument == null) {
      return const SizedBox.shrink();
    } else {
      return InstrumentModel(instrument: instrument!, child: widget.child);
    }
  }
}
