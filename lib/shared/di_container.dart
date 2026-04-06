import 'package:get_it/get_it.dart';
import 'event_bus.dart';
import 'theme_provider.dart';
import 'command_executor.dart';
import '../core/connection.dart';
import '../core/connection_factory.dart';
import '../core/interfaces.dart';
import '../features/generator/generator.dart';
import '../features/ps/ps.dart';

final getIt = GetIt.instance;

void setupDependencies({ConnectionType type = ConnectionType.mock}) {
  getIt.registerLazySingleton<IEventBus>(() => AppEventBus());
  getIt.registerLazySingleton<ThemeProvider>(() => ThemeProvider());
  
  getIt.registerLazySingleton<IConnection>(
    () => ConnectionFactory.create(type),
  );
  
  getIt.registerFactory<CommandExecutor>(
    () => CommandExecutor(
      getIt<IConnection>(),
      getIt<IEventBus>(),
    ),
  );

  // Generator
  getIt.registerFactory<GeneratorService>(
    () => GeneratorService(getIt<CommandExecutor>()),
  );

  getIt.registerFactory<GeneratorController>(
    () => GeneratorController(
      eventBus: getIt<IEventBus>(),
      service: getIt<GeneratorService>(),
    ),
  );

  // PS
  getIt.registerFactory<PSService>(
    () => PSService(getIt<CommandExecutor>()),
  );

  getIt.registerFactory<PSController>(
    () => PSController(
      eventBus: getIt<IEventBus>(),
      service: getIt<PSService>(),
    ),
  );
}