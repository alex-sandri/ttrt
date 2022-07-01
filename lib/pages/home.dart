import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ttrt/bloc/game/bloc.dart';
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
      body: Column(
        children: const [
          Spacer(),
          _BottomBar(),
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
