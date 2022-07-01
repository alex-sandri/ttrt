import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:ttrt/bloc/game/bloc.dart';
import 'package:ttrt/bloc/player/bloc.dart';
import 'package:ttrt/bloc/player/state.dart';
import 'package:ttrt/constants/colors.dart';
import 'package:ttrt/pages/game.dart';
import 'package:ttrt/pages/settings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TTRT'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const SettingsPage())),
            tooltip: 'Settings',
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Stack(
        children: [
          const Opacity(
            opacity: 0.5,
            child: _Background(),
          ),
          Column(
            children: [
              const Spacer(),
              BlocBuilder<PlayerBloc, PlayerState>(
                builder: (context, state) {
                  if (state.bestScore == null) {
                    return const SizedBox();
                  }

                  return Column(
                    children: [
                      const Text('Best score', style: TextStyle(fontSize: 16)),
                      BlocBuilder<PlayerBloc, PlayerState>(
                        builder: (context, state) {
                          if (state.bestScore == null) {
                            return const SizedBox();
                          }

                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${state.bestScore}',
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(' in '),
                              Text(
                                StopWatchTimer.getDisplayTime(
                                  StopWatchTimer.getMilliSecFromSecond(
                                    state.bestScoreTime!,
                                  ),
                                  hours: false,
                                  milliSecond: false,
                                ),
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              const Spacer(),
              const _BottomBar(),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            context.read<GameBloc>().start();

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const GamePage()),
              (_) => false,
            );
          },
          icon: const Icon(Icons.play_arrow),
          label: const Text('Play'),
        ),
      ),
    );
  }
}

class _Background extends StatefulWidget {
  const _Background();

  @override
  State<_Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<_Background> {
  late final Timer _timer;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    const Duration duration = Duration(seconds: 5);

    _timer = Timer.periodic(duration, (timer) {
      if (!mounted) {
        _timer.cancel();

        return;
      }

      _scrollController.animateTo(
        _scrollController.offset + 1000,
        duration: duration,
        curve: Curves.linear,
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: _scrollController,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: GamePage.itemsPerRow,
      ),
      itemBuilder: (context, _) {
        return SizedBox.square(
          dimension: MediaQuery.of(context).size.width / GamePage.itemsPerRow,
          child: Container(color: colors.random),
        );
      },
    );
  }
}
