import 'package:get_it/get_it.dart';
import '../../../shared/command_executor.dart';
import '../data/repositories/ps_repository_impl.dart';
import '../domain/repositories/i_ps_repository.dart';
import '../presentation/bloc/ps_bloc.dart';

final getIt = GetIt.instance;

void setupPSDependencies() {
  getIt.registerFactory<IPSRepository>(
    () => PSRepositoryImpl(getIt<CommandExecutor>()),
  );
  getIt.registerFactory<PSBloc>(
    () => PSBloc(getIt<IPSRepository>()),
  );
}