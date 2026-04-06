import '../shared/app_events.dart';
import '../shared/event_bus.dart';

abstract class IConnection {
  bool connect();
  void disconnect();
  void sendCommand(String command, dynamic value);
  bool get isConnected;
}

class MockConnection implements IConnection {
  @override
  bool connect() {
    return true;
  }

  @override
  void disconnect() {}

  @override
  void sendCommand(String command, dynamic value) {
    Future.delayed(const Duration(milliseconds: 100), () {
      eventBus.fire(CommandAcknowledgedEvent('OK $command $value'));
    });
  }

  @override
  bool get isConnected => true;
}