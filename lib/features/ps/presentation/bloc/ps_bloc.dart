import 'package:flutter_bloc/flutter_bloc.dart';
import 'ps_event.dart';
import 'ps_state.dart';
import '../../domain/repositories/i_ps_repository.dart';

class PSBloc extends Bloc<PSEvent, PSState> {
  final IPSRepository _repository;

  PSBloc(this._repository) : super(PSInitial()) {
    on<SetPSFrequencyEvent>(_onSetFrequency);
  }

  Future<void> _onSetFrequency(
    SetPSFrequencyEvent event,
    Emitter<PSState> emit,
  ) async {
    emit(PSLoading());
    try {
      final success = await _repository.setFrequency(event.frequency);
      if (success) {
        emit(PSFrequencyUpdated(event.frequency));
      } else {
        emit(PSError('Failed to set frequency'));
      }
    } catch (e) {
      emit(PSError(e.toString()));
    }
  }
}