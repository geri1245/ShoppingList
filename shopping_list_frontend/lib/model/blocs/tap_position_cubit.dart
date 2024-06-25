import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/model/state/tap_position_state.dart';

class TapPositionStateCubit extends Cubit<TapPositionState> {
  TapPositionStateCubit() : super(TapPositionState(offset: null));

  void updateTapPosition(Offset offset) {
    emit(TapPositionState(offset: offset));
  }

  Offset? getTapStartPosition() => state.offset;
}
