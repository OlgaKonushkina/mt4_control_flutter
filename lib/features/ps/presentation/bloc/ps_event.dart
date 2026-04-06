import 'package:equatable/equatable.dart';

abstract class PSEvent extends Equatable {
  const PSEvent();

  @override
  List<Object?> get props => [];
}

class SetPSFrequencyEvent extends PSEvent {
  final double frequency;

  const SetPSFrequencyEvent(this.frequency);

  @override
  List<Object?> get props => [frequency];
}

class SetPSStepEvent extends PSEvent {
  final double step;

  const SetPSStepEvent(this.step);

  @override
  List<Object?> get props => [step];
}

class SetPSAmplitudeEvent extends PSEvent {
  final int amplitude;

  const SetPSAmplitudeEvent(this.amplitude);

  @override
  List<Object?> get props => [amplitude];
}

class SetPSPll2Event extends PSEvent {
  final int pll2;

  const SetPSPll2Event(this.pll2);

  @override
  List<Object?> get props => [pll2];
}

class SetPSDoubler2Event extends PSEvent {
  final bool enabled;

  const SetPSDoubler2Event(this.enabled);

  @override
  List<Object?> get props => [enabled];
}