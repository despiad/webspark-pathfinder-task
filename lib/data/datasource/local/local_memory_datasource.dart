import 'dart:async';

import 'package:webspark_task/data/datasource/local/local_datasource.dart';
import 'package:webspark_task/domain/models/solution.dart';

final class LocalMemoryDatasource implements LocalDatasource {
  final List<Solution> _cache = List.empty(growable: true);

  @override
  FutureOr<List<Solution>> readSolutions() {
    return _cache;
  }

  @override
  FutureOr<void> writeSolution(Solution solution) {
    _cache.add(solution);
  }

  @override
  FutureOr<void> writeSolutions(List<Solution> solutions) {
    _cache.addAll(solutions);
  }

  @override
  FutureOr<void> clear() {
    _cache.clear();
  }
}
