import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mt4_control/features/connection/domain/repositories/i_connection_repository.dart';
import 'connection_event.dart';
import 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnState> {
  final IConnectionRepository _repository;

  ConnectionBloc(this._repository) : super(ConnInitial()) {
    on<ConnectEvent>(_onConnect);
    on<DisconnectEvent>(_onDisconnect);
  }

  Future<void> _onConnect(ConnectEvent event, Emitter<ConnState> emit) async {
    emit(ConnConnecting(event.config));
    final success = await _repository.connect(event.config);
    if (success) {
      emit(ConnConnected(event.config));
    } else {
      emit(const ConnError('Failed to connect'));
    }
  }

  Future<void> _onDisconnect(DisconnectEvent event, Emitter<ConnState> emit) async {
    await _repository.disconnect();
    emit(ConnDisconnected());
  }
}