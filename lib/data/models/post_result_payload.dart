import 'package:webspark_task/domain/models/solution.dart';

import '../../utils/utils.dart';

class PostResultPayload {
  String id;
  Result result;

  PostResultPayload({
    required this.id,
    required this.result,
  });

  factory PostResultPayload.fromMap(Map<String, dynamic> json) =>
      PostResultPayload(
        id: json["id"],
        result: Result.fromMap(json["result"]),
      );

  factory PostResultPayload.fromSolution(Solution solution) =>
      PostResultPayload(
        id: solution.task.id,
        result: Result(
            path: Utils.formatPath(solution.path),
            steps: solution.path
                .map(
                  (e) => Step(x: e.x.toString(), y: e.y.toString()),
                )
                .toList()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "result": result.toJson(),
      };
}

class Result {
  List<Step> steps;
  String path;

  Result({
    required this.steps,
    required this.path,
  });

  factory Result.fromMap(Map<String, dynamic> json) => Result(
        steps: List<Step>.from(json["steps"].map((x) => Step.fromMap(x))),
        path: json["path"],
      );

  Map<String, dynamic> toJson() => {
        "steps": List<dynamic>.from(steps.map((x) => x.toJson())),
        "path": path,
      };
}

class Step {
  String x;
  String y;

  Step({
    required this.x,
    required this.y,
  });

  factory Step.fromMap(Map<String, dynamic> json) => Step(
        x: json["x"],
        y: json["y"],
      );

  Map<String, dynamic> toJson() => {
        "x": x,
        "y": y,
      };
}
