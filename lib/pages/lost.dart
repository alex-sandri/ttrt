import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ttrt/bloc/game/bloc.dart';
import 'package:ttrt/bloc/game/state.dart';
import 'package:ttrt/pages/game.dart';
import 'package:ttrt/pages/home.dart';

class LostPage extends StatelessWidget {
  const LostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You lost!',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Padding(
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<GameBloc>().start();

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const GamePage()),
                    (_) => false,
                  );
                },
                icon: const Icon(Icons.restart_alt),
                label: const Text('Retry'),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomePage()),
                (_) => false,
              ),
              icon: const Icon(Icons.logout),
              label: const Text('Quit'),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.red),
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
