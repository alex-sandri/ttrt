import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ttrt/bloc/game/bloc.dart';
import 'package:ttrt/config/theme.dart';
import 'package:ttrt/pages/home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameBloc>(
      create: (_) => GameBloc(),
      child: MaterialApp(
        title: 'TTRT',
        theme: ThemeConfig.dark(),
        home: const HomePage(),
      ),
    );
  }
}
