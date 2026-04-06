import 'package:get_it/get_it.dart';
import '../../../shared/command_executor.dart';
import '../data/repositories/att_repository_impl.dart';
import '../domain/repositories/i_att_repository.dart';
import '../presentation/bloc/att_bloc.dart';

final getIt = GetIt.instance;

void setupATTDependencies() {
  getIt.registerFactory<IATTRepository>(
    () => ATTRepositoryImpl(getIt<CommandExecutor>()),
  );
  getIt.registerFactory<ATTBloc>(
    () => ATTBloc(getIt<IATTRepository>()),
  );
}