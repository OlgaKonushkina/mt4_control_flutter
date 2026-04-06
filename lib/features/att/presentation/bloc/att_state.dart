import 'package:equatable/equatable.dart';

abstract class ATTState extends Equatable {
  const ATTState();

  @override
  List<Object?> get props => [];
}

class ATTInitial extends ATTState {}

class ATTLoading extends ATTState {}

class ATT1Updated extends ATTState {
  final int value;

  const ATT1Updated(this.value);

  @override
  List<Object?> get props => [value];
}

class ATT2Updated extends ATTState {
  final int value;

  const ATT2Updated(this.value);

  @override
  List<Object?> get props => [value];
}

class ATTError extends ATTState {
  final String message;

  const ATTError(this.message);

  @override
  List<Object?> get props => [message];
}