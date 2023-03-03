import 'package:flutter/material.dart';
import 'theme.dart';
import 'routes.dart';

class SongsRoute extends StatelessWidget {
  static WidgetBuilder builder = (context) => const SongsRoute();

  const SongsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (routeArgs is SongRouteArguments) {
      return Center(child: ThemeStyledText('song ${routeArgs.songId}'));
    } else {
      return const Center(child: ThemeStyledText('songs'));
    }
  }
}
