import 'dart:developer';
import 'dart:math' as math;

import 'package:characters/characters.dart';
import 'package:webspark_task/data/datasource/local/local_datasource.dart';
import 'package:webspark_task/data/datasource/remote_datasource.dart';
import 'package:webspark_task/data/models/post_result_payload.dart';
import 'package:webspark_task/domain/models/cell.dart';
import 'package:webspark_task/domain/models/solution.dart';
import 'package:webspark_task/domain/models/task.dart';
import 'package:webspark_task/utils/extensions.dart';

final class DataRepository {
  final RemoteDatasource _remoteDatasource;
  final LocalDatasource _localStorageDatasource;
  final LocalDatasource _localCache;

  DataRepository({
    required RemoteDatasource remoteDatasource,
    required LocalDatasource localStorageDatasource,
    required LocalDatasource localCache,
  })  : _remoteDatasource = remoteDatasource,
        _localStorageDatasource = localStorageDatasource,
        _localCache = localCache;

  Future<bool> checkUrlMethods(String url) async {
    final response = await _remoteDatasource.checkUrlAllowedMethods(url);
    return response.toLowerCase().contains('get');
  }

  Future<List<Task>> getGrids(String url) async {
    final response = await _remoteDatasource.getData(url);
    List<Task> grids = List.empty(growable: true);

    for (var d in response.data) {
      final grid = _parseGrid(d.field);
      final start = Cell(x: d.start.x, y: d.start.y);
      final end = Cell(x: d.end.x, y: d.end.y);
      grids.add(Task(id: d.id, grid: grid, start: start, end: end));
    }

    return grids;
  }

  List<Cell> search(List<List<Cell>> grid, Cell start, Cell end) {
    Set<Cell> open = <Cell>{start};
    final cameFrom = <Cell, Cell>{};

    // since all the cells start with g = double.infinity
    // there is a need to set initial value to 0 to actually start finding a path
    final gScore = <Cell, double>{};
    gScore[start] = 0;

    // For cell c, fScore[c] := gScore[c] + h(c)
    final fScore = <Cell, double>{};
    fScore[start] = _getHeuristic(start, end);

    while (open.isNotEmpty) {
      final cur = _getBest(open, fScore);
      log('Processing ${cur.x} ${cur.y}');
      if (cur == end) {
        log('--- DONE ---');
        return _getPath(cameFrom, cur);
      }
      open.remove(cur);

      final neighbours = _getNeighbours(grid, cur);

      for (var neighbour in neighbours) {
        final newG = gScore[cur]! + 1.0;
        if (newG < gScore.getOrDefault(neighbour, double.infinity)) {
          cameFrom[neighbour] = cur;
          gScore[neighbour] = newG;
          fScore[neighbour] = newG + _getHeuristic(neighbour, end);
          if (!open.contains(neighbour)) {
            open.add(neighbour);
          }
        }
      }
    }
    return [];
  }

  Future<void> sendResults(String url, List<Solution> solutions) async {
    final payload = List<PostResultPayload>.from(solutions
        .map<PostResultPayload>(
          (solution) => PostResultPayload.fromSolution(solution),
        )
        .toList());

    await _remoteDatasource.sendResults(url, payload);
  }

  /// Saves both to cache and local storage.
  Future<void> saveSolutions(List<Solution> solutions) async {
    await _localCache.writeSolutions(solutions);
    await _localStorageDatasource.writeSolutions(solutions);
  }

  Future<List<Solution>> getSolutions() async {
    final cachedSolutions = await _localCache.readSolutions();
    if (cachedSolutions.isEmpty) {
      final stored = await _localStorageDatasource.readSolutions();
      await _localCache.writeSolutions(stored);
      return stored;
    }
    return cachedSolutions;
  }

  Future<List<Solution>> loadInCache() async {
    await _localCache.clear();
    final stored = await _localStorageDatasource.readSolutions();
    await _localCache.writeSolutions(stored);
    return stored;
  }

  /// Transform ".X..X" pattern into a `Cell` matrix.
  List<List<Cell>> _parseGrid(List<String> data) {
    List<List<Cell>> grid = List.empty(growable: true);
    for (int i = 0; i < data.length; i++) {
      final row = data[i];
      final List<Cell> gridRow = List.empty(growable: true);
      for (int j = 0; j < row.characters.length; j++) {
        final ch = row.characters.elementAt(j);
        final cell = Cell(x: i, y: j, blocked: ch == 'X');
        gridRow.add(cell);
      }
      grid.add(gridRow);
    }
    return grid;
  }

  /// Calculates the heuristic based
  /// on the Euclidean formulae of distance between two points:
  ///
  /// `√((x2 – x1)² + (y2 – y1)²)`.
  double _getHeuristic(Cell start, Cell end) {
    return math
        .sqrt(math.pow((end.x - start.x), 2) + math.pow((end.y - start.y), 2));
  }

  /// Returns a cell with the lowest f in the provided set.
  Cell _getBest(Set<Cell> open, Map<Cell, double> fScore) {
    late Cell best = open.first;

    for (var cell in open) {
      if ((fScore.getOrDefault(cell, double.infinity)) <
          fScore.getOrDefault(best, double.infinity)) {
        best = cell;
      }
    }

    return best;
  }

  /// Calculates and returns all the possible neighbours of the `target`
  /// which are not obstacles (not blocked) and fit in the grid.
  List<Cell> _getNeighbours(List<List<Cell>> grid, Cell target) {
    final directions = [
      [0, -1], // up
      [1, -1], // up-right
      [1, 0], // right
      [1, 1], // down-right
      [0, 1], // down
      [-1, 1], // down-left
      [-1, 0], // left
      [-1, -1], // up-left
    ];

    final neighbours = <Cell>[];
    for (var dir in directions) {
      final neighbourPos = math.Point(target.x + dir[0], target.y + dir[1]);

      // check if it can exist in the grid
      if (neighbourPos.x.inRange(0, grid.first.length) &&
          neighbourPos.y.inRange(0, grid.length)) {
        final neighbour = grid[neighbourPos.x][neighbourPos.y];
        // check if not blocked
        if (!neighbour.blocked) {
          neighbours.add(neighbour);
        }
      }
    }
    return neighbours;
  }

  /// Returns path to the `end` as list of `Cell`s
  /// where the first is the start.
  List<Cell> _getPath(Map<Cell, Cell> cameFrom, Cell end) {
    List<Cell> path = List<Cell>.empty(growable: true);
    Cell? cur = end;
    path.add(cur);
    while (cur != null) {
      cur = cameFrom[cur];
      if (cur != null) {
        path.add(cur);
      }
    }

    return path.reversed.toList();
  }
}
