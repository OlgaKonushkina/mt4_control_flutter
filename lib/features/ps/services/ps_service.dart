import '../../../shared/command.dart';
import '../../../shared/command_executor.dart';

class PSService {
  final CommandExecutor _executor;

  PSService(this._executor);

  Future<bool> setFrequency(double value) async {
    final command = SetFrequencyCommand('PS', value);
    return await _executor.execute(command);
  }
}