import 'package:equatable/equatable.dart';

abstract class ATTEvent extends Equatable {
  const ATTEvent();

  @override
  List<Object?> get props => [];
}

class SetATT1Event extends ATTEvent {
  final int value;

  const SetATT1Event(this.value);

  @override
  List<Object?> get props => [value];
}

class SetATT2Event extends ATTEvent {
  final int value;

  const SetATT2Event(this.value);

  @override
  List<Object?> get props => [value];
}