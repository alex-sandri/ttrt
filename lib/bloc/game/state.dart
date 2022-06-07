import 'package:flutter/material.dart';

class GameState {
  final bool isPaused;
  final Color currentColor;

  final int score;
  final int errors;

  const GameState({
    this.isPaused = false,
    this.currentColor = Colors.red,
    this.score = 0,
    this.errors = 0,
  });

  GameState copyWith({
    bool? isPaused,
    Color? currentColor,
    int? score,
    int? errors,
  }) =>
      GameState(
        isPaused: isPaused ?? this.isPaused,
        currentColor: currentColor ?? this.currentColor,
        score: score ?? this.score,
        errors: errors ?? this.errors,
      );
}
