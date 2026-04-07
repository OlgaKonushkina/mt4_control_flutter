import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mt4_control/features/connection/domain/repositories/i_connection_repository.dart';
import 'connection_event.dart';
import 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnState> {
  final IConnectionRepository _repository;

  ConnectionBloc(this._repository) : super(ConnInitial()) {
    on<ConnectEvent>(_onConnect);
    on<DisconnectEvent>(_onDisconnect);
    on<ChangeConnectionTypeEvent>(_onChangeType);
  }

  Future<void> _onConnect(ConnectEvent event, Emitter<ConnState> emit) async {
    emit(ConnConnecting(event.config));
    final result = await _repository.connect(event.config);
    emit(result);
  }

  Future<void> _onDisconnect(DisconnectEvent event, Emitter<ConnState> emit) async {
    await _repository.disconnect();
    emit(ConnDisconnected());
  }

  void _onChangeType(ChangeConnectionTypeEvent event, Emitter<ConnState> emit) {
    // Просто меняем тип
  }
}