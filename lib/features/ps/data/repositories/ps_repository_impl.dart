import '../../../../shared/command.dart';
import '../../../../shared/command_executor.dart';
import '../../domain/repositories/i_ps_repository.dart';

class PSRepositoryImpl implements IPSRepository {
  final CommandExecutor _executor;

  PSRepositoryImpl(this._executor);

  @override
  Future<bool> setFrequency(double value) async {
    final command = SetFrequencyCommand('PS', value);
    return await _executor.execute(command);
  }

  @override
  Future<bool> setStep(double value) async {
    final command = SetStepCommand('PS', value);
    return await _executor.execute(command);
  }

  @override
  Future<bool> setAmplitude(int value) async {
    final command = SetAmplitudeCommand('1', value);
    return await _executor.execute(command);
  }

  @override
  Future<bool> setPll2(int value) async {
    final command = SetPLLCommand('2', value);
    return await _executor.execute(command);
  }

  @override
  Future<bool> setDoubler2(bool enabled) async {
    final command = SetDoublerCommand('2', enabled);
    return await _executor.execute(command);
  }
}