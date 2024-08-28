import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webspark_task/app.dart';
import 'package:webspark_task/bloc_observer.dart';
import 'package:webspark_task/data/datasource/local/local_file_datasource.dart';
import 'package:webspark_task/data/datasource/local/local_memory_datasource.dart';
import 'package:webspark_task/data/datasource/remote_datasource.dart';
import 'package:webspark_task/di/dependencies_container.dart';
import 'package:webspark_task/domain/repo/data_repo.dart';

Future<void> main() async {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  final dependencies = await _initDependencies();
  runApp(MyApp(dependencies: dependencies));
}

Future<DependenciesContainer> _initDependencies() async {
  final remoteDatasource = RemoteDatasource();
  final localFileDatasource = await LocalFileDatasource.init('database');
  final localCache = LocalMemoryDatasource();
  final dataRepository = DataRepository(
    remoteDatasource: remoteDatasource,
    localStorageDatasource: localFileDatasource,
    localCache: localCache,
  );
  final dependencies = DependenciesContainer(dataRepository: dataRepository);
  return dependencies;
}
