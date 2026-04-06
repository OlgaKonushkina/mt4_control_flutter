import 'package:equatable/equatable.dart';
import '../repositories/i_generator_repository.dart';

class SetFrequencyUseCase {
  final IGeneratorRepository repository;

  SetFrequencyUseCase(this.repository);

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