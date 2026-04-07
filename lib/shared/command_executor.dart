import 'dart:async';
import '../core/interfaces/connection.dart';
import 'app_events.dart';
import 'command.dart';
import 'event_bus.dart';

class CommandExecutor {
  final IConnection _connection;
  final IEventBus _eventBus;
  Completer<bool>? _currentCompleter;

  CommandExecutor(this._connection, this._eventBus);

  Future<bool> execute(Command command) async {
    if (!command.validate()) {
      return false;
    }

    for (int attempt = 0; attempt < command.retries; attempt++) {
      _connection.sendCommand(command.name, command.value);

      _currentCompleter = Completer<bool>();

      void handler(CommandAcknowledgedEvent event) {
        if (event.command.contains(command.name) && !_currentCompleter!.isCompleted) {
          _currentCompleter!.complete(true);
        }
      }

      _eventBus.subscribe<CommandAcknowledgedEvent>(handler);

      try {
        final result = await _currentCompleter!.future.timeout(command.timeout);
        _eventBus.unsubscribe<CommandAcknowledgedEvent>(handler);
        _currentCompleter = null;
        return result;
      } catch (e) {
        _eventBus.unsubscribe<CommandAcknowledgedEvent>(handler);
        if (!_currentCompleter!.isCompleted) {
          _currentCompleter!.completeError(e);
        }
        _currentCompleter = null;
      }
    }
    return false;
  }
}