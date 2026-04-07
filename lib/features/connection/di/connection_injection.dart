import 'package:get_it/get_it.dart';
import '../data/repositories/connection_repository_impl.dart';
import '../domain/repositories/i_connection_repository.dart';
import '../presentation/bloc/connection_bloc.dart';

final getIt = GetIt.instance;

void setupConnectionDependencies() {
  getIt.registerLazySingleton<IConnectionRepository>(
    () => ConnectionRepositoryImpl(),
  );
  getIt.registerFactory<ConnectionBloc>(
    () => ConnectionBloc(getIt<IConnectionRepository>()),
  );
}