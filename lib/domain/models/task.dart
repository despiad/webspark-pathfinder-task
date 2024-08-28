
import 'package:webspark_task/domain/models/cell.dart';

final class Task {
  final String id;
  final Cell start;
  final Cell end;
  final List<List<Cell>> grid;

  Task({
    required this.id,
    required this.grid,
    required this.start,
    required this.end,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json["id"],
    start: Cell.fromJson(json["start"]),
    end: Cell.fromJson(json["end"]),
    grid: List<List<Cell>>.from(json["grid"].map((x) => List<Cell>.from(x.map((x) => Cell.fromJson(x))))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "start": start.toJson(),
    "end": end.toJson(),
    "grid": List<dynamic>.from(grid.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
  };
}
