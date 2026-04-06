import 'package:event_bus/event_bus.dart';
import '../core/interfaces.dart';

final eventBus = EventBus();

class AppEventBus implements IEventBus {
  @override
  void subscribe<T>(void Function(T event) handler) {
    eventBus.on<T>().listen((event) => handler(event));
  }

  @override
  void unsubscribe<T>(void Function(T event) handler) {
    // временная заглушка
  }

  @override
  void publish<T>(T event) {
    eventBus.fire(event);
  }
}