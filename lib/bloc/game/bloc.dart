import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:ttrt/bloc/game/state.dart';
import 'package:ttrt/bloc/player/bloc.dart';
import 'package:ttrt/constants/colors.dart';

class GameBloc extends Cubit<GameState> {
  static const int loseAfterErrors = 3;

  final StopWatchTimer timer;

  GameBloc({required this.timer}) : super(const GameState());

  void start() => emit(const GameState());

  void toggleIsPaused() {
    final bool willBePaused = !state.isPaused;

    timer.onExecute
        .add(willBePaused ? StopWatchExecute.stop : StopWatchExecute.start);

    emit(state.copyWith(isPaused: willBePaused));
  }

  void changeCurrentColor() =>
      emit(state.copyWith(currentColor: colors.random));

  Future<void> handleTap(Color color, {required BuildContext context}) async {
    if (state.currentColor != color) {
      final int errors = state.errors + 1;

      emit(state.copyWith(errors: errors));

      return;
    }

    final int score = state.score + 1;

    emit(state.copyWith(score: score));

    {
      final int bestScore = context.read<PlayerBloc>().state.bestScore ?? 0;

      if (score > bestScore) {
        final PlayerBloc bloc = context.read<PlayerBloc>();

        bloc.changeBestScore(score, timer.secondTime.value);

        await bloc.save();
      }
    }
  }
}
