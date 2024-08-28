import 'package:webspark_task/domain/models/cell.dart';
import 'package:webspark_task/domain/models/task.dart';

final class Solution {
  final Task task;
  final List<Cell> path;

  Solution({required this.task, required this.path});

  factory Solution.fromJson(Map<String, dynamic> json) => Solution(
    task: Task.fromJson(json["task"]),
    path: List<Cell>.from(json["cell"].map((x) => Cell.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "task": task.toJson(),
    "cell": List<dynamic>.from(path.map((x) => x.toJson())),
  };
}
