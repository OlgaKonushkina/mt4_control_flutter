abstract class AppEvent {
  const AppEvent();
}

class GeneratorFrequencyChangedEvent extends AppEvent {
  final double value;
  const GeneratorFrequencyChangedEvent(this.value);
}

class CommandAcknowledgedEvent extends AppEvent {
  final String command;
  const CommandAcknowledgedEvent(this.command);
}