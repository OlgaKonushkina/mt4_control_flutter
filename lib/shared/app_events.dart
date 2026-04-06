import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class CommandAcknowledgedEvent extends AppEvent {
  final String command;
  const CommandAcknowledgedEvent(this.command);

  @override
  List<Object?> get props => [command];
}

class GeneratorFrequencyChangedEvent extends AppEvent {
  final double value;
  const GeneratorFrequencyChangedEvent(this.value);

  @override
  List<Object?> get props => [value];
}