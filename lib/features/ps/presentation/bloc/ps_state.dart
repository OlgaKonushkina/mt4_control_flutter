import 'package:equatable/equatable.dart';

abstract class PSState extends Equatable {
  const PSState();

  @override
  List<Object?> get props => [];
}

class PSInitial extends PSState {}

class PSLoading extends PSState {}

class PSFrequencyUpdated extends PSState {
  final double frequency;

  const PSFrequencyUpdated(this.frequency);

  @override
  List<Object?> get props => [frequency];
}

class PSError extends PSState {
  final String message;

  const PSError(this.message);

  @override
  List<Object?> get props => [message];
}