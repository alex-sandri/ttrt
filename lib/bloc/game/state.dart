import 'package:flutter/material.dart';

class GameState {
  final bool isPaused;
  final Color currentColor;

  final int time;
  final int score;
  final int errors;

  const GameState({
    this.isPaused = false,
    this.currentColor = Colors.red,
    this.time = 0,
    this.score = 0,
    this.errors = 0,
  });

  int get timeInSeconds => time ~/ 1000;

  GameState copyWith({
    bool? isPaused,
    Color? currentColor,
    int? time,
    int? score,
    int? errors,
  }) =>
      GameState(
        isPaused: isPaused ?? this.isPaused,
        currentColor: currentColor ?? this.currentColor,
        time: time ?? this.time,
        score: score ?? this.score,
        errors: errors ?? this.errors,
      );
}
