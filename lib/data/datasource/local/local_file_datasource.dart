import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:webspark_task/data/datasource/local/local_datasource.dart';
import 'package:webspark_task/domain/models/solution.dart';

/// LocalDatasource is used to store and read
/// pathfinding results data from a file.
///
/// Must call `init()` before passing to other constructors.
final class LocalFileDatasource implements LocalDatasource {
  final String dataStoreFullPath;

  LocalFileDatasource._({required this.dataStoreFullPath});

  static Future<LocalFileDatasource> init(String databaseFileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$databaseFileName.txt');
    return LocalFileDatasource._(dataStoreFullPath: file.path);
  }

  @override
  Future<void> writeSolution(Solution solution) async {
    final file = File(dataStoreFullPath);
    final access = await file.open(mode: FileMode.append);
    await access.writeString(jsonEncode(solution.toJson()));
  }

  @override
  FutureOr<void> writeSolutions(List<Solution> solutions) async {
    final file = File(dataStoreFullPath);
    final access = await file.open(mode: FileMode.writeOnlyAppend);
    for (var s in solutions) {
      await access.writeString('${jsonEncode(s.toJson())}\n');
    }
  }

  @override
  Future<List<Solution>> readSolutions() async {
    return await _parseFromFile(dataStoreFullPath);
  }

  static Future<List<Solution>> _parseFromFile(String filename) async {
    final content = await File(filename).readAsLines();
    List<Solution> solutions = List<Solution>.empty(growable: true);
    for (var line in content) {
      solutions
          .add(Solution.fromJson(jsonDecode(line) as Map<String, dynamic>));
    }
    return solutions;
  }

  @override
  FutureOr<void> clear() async {
    final file = File(dataStoreFullPath);
    file.writeAsString("");
  }
}
