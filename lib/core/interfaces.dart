abstract class IEventBus {
  void subscribe<T>(void Function(T event) handler);
  void unsubscribe<T>(void Function(T event) handler);
  void publish<T>(T event);
}