import 'package:flutter/material.dart';
import 'package:webspark_task/di/dependencies_container.dart';
import 'package:webspark_task/di/dependencies_scope.dart';
import 'package:webspark_task/screens/home/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.dependencies});

  final DependenciesContainer dependencies;

  @override
  Widget build(BuildContext context) {
    return DependenciesScope(
      dependencies: dependencies,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
