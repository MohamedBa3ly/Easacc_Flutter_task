import 'package:get_it/get_it.dart';

import '../../data/repository/task_repository_impl.dart';

final getIt = GetIt.instance;

void setupServiceLocator(){
  getIt.registerSingleton<TaskRepositoryImpl>(TaskRepositoryImpl());
}

