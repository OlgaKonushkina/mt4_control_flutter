import 'package:get_it/get_it.dart';
import '../core/interfaces/connection.dart';
import 'command_executor.dart';
import 'event_bus.dart';
import 'theme_provider.dart';
import '../features/generator/generator.dart';
import '../features/ps/ps.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<IEventBus>(() => AppEventBus());
  getIt.registerLazySingleton<ThemeProvider>(() => ThemeProvider());
  getIt.registerLazySingleton<IConnection>(() => MockConnection());
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