import 'package:equatable/equatable.dart';

class ATT1State extends Equatable {
  final int value;  // 0, 1, 2

  const ATT1State(this.value);

  @override
  List<Object?> get props => [value];
}

class ATT2State extends Equatable {
  final int value;  // 0, 1

  const ATT2State(this.value);

  @override
  List<Object?> get props => [value];
}