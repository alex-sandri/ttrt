import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ttrt/bloc/player/state.dart';

class PlayerBloc extends Cubit<PlayerState> {
  PlayerBloc(super.initialState);

  void changeBestScore(int value, int time) =>
      emit(state.copyWith(bestScore: value, bestScoreTime: time));

  Future<void> save() => state.save();
}
