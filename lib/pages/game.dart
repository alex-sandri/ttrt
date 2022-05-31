import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ttrt/bloc/game/bloc.dart';
import 'package:ttrt/bloc/game/state.dart';
import 'package:ttrt/constants/colors.dart';
import 'package:ttrt/pages/home.dart';
import 'package:ttrt/pages/lost.dart';

class GamePage extends StatelessWidget {
  static const int itemsPerRow = 4;

  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<GameBloc, GameState>(
        builder: (context, state) {
          return Column(
            children: [
              const _ProgressIndicator(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < GameBloc.loseAfterErrors; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 5,
                      ),
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor:
                            i < state.errors ? Colors.red : Colors.blue,
                      ),
                    ),
                ],
              ),
              const Expanded(child: Center(child: _Grid())),
              const _GameStatus(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                child: ElevatedButton.icon(
                  onPressed: context.read<GameBloc>().toggleIsPaused,
                  icon: const Icon(Icons.pause),
                  label: const Text('Pause'),
                ),
              ),
            ],
          );
        },
        listener: (context, state) {
          if (state.errors == GameBloc.loseAfterErrors) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LostPage()),
              (_) => false,
            );
          } else if (state.isPaused) {
            showDialog(
              context: context,
              builder: (context) {
                return WillPopScope(
                  onWillPop: () => Future.value(false),
                  child: AlertDialog(
                    title: const Text('Paused'),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const HomePage()),
                          (_) => false,
                        ),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.red),
                        ),
                        child: const Text('Quit'),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<GameBloc>().toggleIsPaused();

                          Navigator.pop(context);
                        },
                        child: const Text('Resume'),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
        listenWhen: (previous, current) =>
            previous.errors != current.errors ||
            previous.isPaused != current.isPaused,
      ),
    );
  }
}

class _GameStatus extends StatefulWidget {
  const _GameStatus();

  @override
  State<_GameStatus> createState() => _GameStatusState();
}

class _GameStatusState extends State<_GameStatus> {
  static const int ticksPerSecond = 200;

  @override
  void initState() {
    super.initState();

    Timer.periodic(
      const Duration(milliseconds: 1000 ~/ ticksPerSecond),
      (timer) {
        if (!mounted) {
          timer.cancel();

          return;
        }

        context.read<GameBloc>().incrementTime(1000 ~/ ticksPerSecond);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          final String minutesString =
              '${state.timeInSeconds ~/ 60}'.padLeft(2, '0');
          final String secondsString =
              '${state.timeInSeconds % 60}'.padLeft(2, '0');

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text('Time', style: TextStyle(fontSize: 16)),
                  Text(
                    '$minutesString:$secondsString',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('Score', style: TextStyle(fontSize: 16)),
                  Text(
                    '${state.score}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Grid extends StatefulWidget {
  const _Grid();

  @override
  State<_Grid> createState() => _GridState();
}

class _GridState extends State<_Grid> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: MediaQuery.of(context).size.width * 0.9,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: GamePage.itemsPerRow,
        ),
        itemCount: GamePage.itemsPerRow * GamePage.itemsPerRow,
        itemBuilder: (context, index) {
          final Color color = colors.random;

          return GestureDetector(
            onTap: () {
              context.read<GameBloc>().handleTap(color);

              setState(() {});
            },
            child: SizedBox.square(
              dimension:
                  MediaQuery.of(context).size.width / GamePage.itemsPerRow,
              child: Container(color: color),
            ),
          );
        },
      ),
    );
  }
}

class _ProgressIndicator extends StatefulWidget {
  const _ProgressIndicator();

  @override
  State<_ProgressIndicator> createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<_ProgressIndicator> {
  static const int durationInSeconds = 5;
  static const int ticksPerSecond = 200;

  double _progress = 0;

  @override
  void initState() {
    super.initState();

    Timer.periodic(
      const Duration(milliseconds: 1000 ~/ ticksPerSecond),
      (timer) {
        if (!mounted) {
          timer.cancel();

          return;
        }

        final double millisecondsElapsedSinceLastColor =
            context.read<GameBloc>().state.time % (durationInSeconds * 1000);

        double progress =
            millisecondsElapsedSinceLastColor / (durationInSeconds * 1000);

        if (progress < _progress) {
          progress = 0;

          context.read<GameBloc>().changeCurrentColor();
        }

        setState(() => _progress = progress);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return Material(
          child: LinearProgressIndicator(
            value: 1 - _progress,
            valueColor: AlwaysStoppedAnimation(state.currentColor),
            backgroundColor: state.currentColor.withOpacity(0.2),
            minHeight: 20,
          ),
        );
      },
    );
  }
}
