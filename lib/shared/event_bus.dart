import 'package:event_bus/event_bus.dart';

final eventBus = EventBus();

abstract class IEventBus {
  void subscribe<T>(void Function(T event) handler);
  void unsubscribe<T>(void Function(T event) handler);
  void publish<T>(T event);
}

class AppEventBus implements IEventBus {
  @override
  void subscribe<T>(void Function(T event) handler) {
    eventBus.on<T>().listen((event) => handler(event));
  }

  @override
  void unsubscribe<T>(void Function(T event) handler) {
    // Заглушка
  }

  @override
  void publish<T>(T event) {
    eventBus.fire(event);
  }
}