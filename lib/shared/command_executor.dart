import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/connection.dart';
import '../core/interfaces.dart';
import 'app_events.dart';
import 'command.dart';

class CommandExecutor {
  final IConnection _connection;
  final IEventBus _eventBus;

  CommandExecutor(this._connection, this._eventBus);

  Future<bool> execute(Command command) async {
    if (!command.validate()) {
      debugPrint('Command validation failed: ${command.name} = ${command.value}');
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
        debugPrint('Attempt ${attempt + 1} failed: timeout');
      }
    }
    return false;
  }
}