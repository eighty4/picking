import 'package:flutter/material.dart';

import 'routes.dart';

class SongsRoute extends StatelessWidget {
  static WidgetBuilder builder = (context) => const SongsRoute();

  const SongsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.settings.arguments is SongRouteArguments) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as SongRouteArguments;
      return Expanded(child: Center(child: Text('song ${arguments.songId}')));
    } else {
      return const Expanded(child: Center(child: Text('songs')));
    }
  }
}
