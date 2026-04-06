import '../../../../shared/command.dart';
import '../../../../shared/command_executor.dart';
import '../../domain/repositories/i_generator_repository.dart';

class GeneratorRepositoryImpl implements IGeneratorRepository {
  final CommandExecutor _executor;

  GeneratorRepositoryImpl(this._executor);

  @override
  Future<bool> setFrequency(double value) async {
    final command = SetFrequencyCommand('GTR', value);
    return await _executor.execute(command);
  }

  @override
  Future<bool> setStep(double value) async {
    final command = SetStepCommand('GTR', value);
    return await _executor.execute(command);
  }

  @override
  Future<bool> setAmplitude(int value) async {
    final command = SetAmplitudeCommand('0', value);
    return await _executor.execute(command);
  }

  @override
  Future<bool> setPll1(int value) async {
    final command = SetPLLCommand('1', value);
    return await _executor.execute(command);
  }

  @override
  Future<bool> setPll3(int value) async {
    final command = SetPLLCommand('3', value);
    return await _executor.execute(command);
  }

  @override
  Future<bool> setDoubler1(bool enabled) async {
    final command = SetDoublerCommand('1', enabled);
    return await _executor.execute(command);
  }
}