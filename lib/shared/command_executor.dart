import 'dart:async';
import '../core/interfaces/connection.dart';
import 'app_events.dart';
import 'command.dart';
import 'event_bus.dart';

class CommandExecutor {
  final IConnection _connection;
  final IEventBus _eventBus;

  CommandExecutor(this._connection, this._eventBus);

  Future<bool> execute(Command command) async {
    if (!command.validate()) {
      return false;
    }

    for (int attempt = 0; attempt < command.retries; attempt++) {
      _connection.sendCommand(command.name, command.value);

      final completer = Completer<bool>();

      void handler(CommandAcknowledgedEvent event) {
        if (event.command.contains(command.name)) {
          completer.complete(true);
        }
      }

      _eventBus.subscribe<CommandAcknowledgedEvent>(handler);

      try {
        final result = await completer.future.timeout(command.timeout);
        _eventBus.unsubscribe<CommandAcknowledgedEvent>(handler);
        return result;
      } catch (e) {
        _eventBus.unsubscribe<CommandAcknowledgedEvent>(handler);
      }
    }
    return false;
  }
}