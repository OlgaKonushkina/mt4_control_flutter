import '../../../shared/command.dart';
import '../../../shared/command_executor.dart';

class GeneratorService {
  final CommandExecutor _executor;

  GeneratorService(this._executor);

  Future<bool> setFrequency(double value) async {
    final command = SetFrequencyCommand('GTR', value);
    return await _executor.execute(command);
  }
}