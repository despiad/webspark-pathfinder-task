import 'dart:async';

import 'package:webspark_task/domain/models/solution.dart';

abstract interface class LocalDatasource {
  FutureOr<void> writeSolution(Solution solution);
  FutureOr<void> writeSolutions(List<Solution> solutions);
  FutureOr<List<Solution>> readSolutions();
  FutureOr<void> clear();
}
