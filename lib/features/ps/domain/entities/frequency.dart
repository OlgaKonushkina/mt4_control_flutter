import 'package:equatable/equatable.dart';

class PSFrequency extends Equatable {
  final double value;

  const PSFrequency(this.value);

  factory PSFrequency.fromDouble(double value) {
    if (value < 100.0 || value > 999.9999) {
      throw ArgumentError('Frequency must be between 100.0 and 999.9999');
    }
    return PSFrequency(value);
  }

  PSFrequency copyWith({double? value}) {
    return PSFrequency(value ?? this.value);
  }

  @override
  List<Object?> get props => [value];
}