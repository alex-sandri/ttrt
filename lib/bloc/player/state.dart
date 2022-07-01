import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttrt/constants/preferences.dart';

class PlayerState {
  final int? bestScore;

  /// The time in seconds of the game that had the best score.
  final int? bestScoreTime;

  const PlayerState({
    this.bestScore,
    this.bestScoreTime,
  });

  PlayerState copyWith({
    int? bestScore,
    int? bestScoreTime,
  }) =>
      PlayerState(
        bestScore: bestScore ?? this.bestScore,
        bestScoreTime: bestScoreTime ?? this.bestScoreTime,
      );

  Future<void> save() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.setInt(kBestScore, bestScore!);
    await preferences.setInt(kBestScoreTime, bestScoreTime!);
  }

  static Future<PlayerState> restore() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return PlayerState(
      bestScore: preferences.getInt(kBestScore),
      bestScoreTime: preferences.getInt(kBestScoreTime),
    );
  }
}
