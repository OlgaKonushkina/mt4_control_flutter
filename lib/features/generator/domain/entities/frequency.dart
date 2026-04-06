import 'package:equatable/equatable.dart';

class Frequency extends Equatable {
  final double value;

  const Frequency(this.value);

  factory Frequency.fromDouble(double value) {
    if (value < 100.0 || value > 999.9999) {
      throw ArgumentError('Frequency must be between 100.0 and 999.9999');
    }
    return Frequency(value);
  }

  Frequency copyWith({double? value}) {
    return Frequency(value ?? this.value);
  }

  @override
  List<Object?> get props => [value];
}