import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mt4_control/features/att/domain/repositories/i_att_repository.dart';
import 'att_event.dart';
import 'att_state.dart';

class ATTBloc extends Bloc<ATTEvent, ATTState> {
  final IATTRepository _repository;

  ATTBloc(this._repository) : super(ATTInitial()) {
    on<SetATT1Event>(_onSetATT1);
    on<SetATT2Event>(_onSetATT2);
  }

  Future<void> _onSetATT1(SetATT1Event event, Emitter<ATTState> emit) async {
    emit(ATTLoading());
    try {
      final success = await _repository.setATT1(event.value);
      if (success) {
        emit(ATT1Updated(event.value));
      } else {
        emit(ATTError('Failed to set ATT1'));
      }
    } catch (e) {
      emit(ATTError(e.toString()));
    }
  }

  Future<void> _onSetATT2(SetATT2Event event, Emitter<ATTState> emit) async {
    emit(ATTLoading());
    try {
      final success = await _repository.setATT2(event.value);
      if (success) {
        emit(ATT2Updated(event.value));
      } else {
        emit(ATTError('Failed to set ATT2'));
      }
    } catch (e) {
      emit(ATTError(e.toString()));
    }
  }
}