import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:ttrt/bloc/game/bloc.dart';
import 'package:ttrt/bloc/player/bloc.dart';
import 'package:ttrt/bloc/player/state.dart';
import 'package:ttrt/config/theme.dart';
import 'package:ttrt/pages/home.dart';

class App extends StatefulWidget {
  final PlayerState playerState;

  const App({
    super.key,
    required this.playerState,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void dispose() async {
    await _stopWatchTimer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GameBloc>(create: (_) => GameBloc(timer: _stopWatchTimer)),
        BlocProvider<PlayerBloc>(create: (_) => PlayerBloc(widget.playerState)),
      ],
      child: MaterialApp(
        title: 'TTRT',
        theme: ThemeConfig.dark(),
        home: const HomePage(),
      ),
    );
  }
}
