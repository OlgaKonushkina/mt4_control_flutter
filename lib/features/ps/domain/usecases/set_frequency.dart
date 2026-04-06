import 'package:equatable/equatable.dart';
import '../repositories/i_ps_repository.dart';

class SetPSFrequencyUseCase {
  final IPSRepository repository;

  SetPSFrequencyUseCase(this.repository);

  Future<bool> call(Params params) async {
    return await repository.setFrequency(params.frequency);
  }
}

class Params extends Equatable {
  final double frequency;

  const Params({required this.frequency});

  @override
  List<Object?> get props => [frequency];
}