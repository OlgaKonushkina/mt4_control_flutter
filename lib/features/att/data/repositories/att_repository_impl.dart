import '../../../../shared/command.dart';
import '../../../../shared/command_executor.dart';
import '../../domain/repositories/i_att_repository.dart';

class ATTRepositoryImpl implements IATTRepository {
  final CommandExecutor _executor;

  ATTRepositoryImpl(this._executor);

  @override
  Future<bool> setATT1(int value) async {
    final command = SetATTCommand('1', value);
    return await _executor.execute(command);
  }

  @override
  Future<bool> setATT2(int value) async {
    final command = SetATTCommand('2', value);
    return await _executor.execute(command);
  }
}