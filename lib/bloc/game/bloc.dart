import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ttrt/bloc/game/state.dart';
import 'package:ttrt/constants/colors.dart';

class GameBloc extends Cubit<GameState> {
  static const int loseAfterErrors = 3;

  GameBloc() : super(const GameState());

  void start() => emit(const GameState());

  void toggleIsPaused() => emit(state.copyWith(isPaused: !state.isPaused));

  void changeCurrentColor() =>
      emit(state.copyWith(currentColor: colors.random));

  /// Increment game time by [milliseconds] milliseconds
  void incrementTime(int milliseconds) {
    if (state.isPaused) {
      return;
    }

    emit(state.copyWith(time: state.time + milliseconds));
  }

  void handleTap(Color color) {
    if (state.currentColor != color) {
      final int errors = state.errors + 1;

      emit(state.copyWith(errors: errors));

      return;
    }

    emit(state.copyWith(score: state.score + 1));
  }
}
