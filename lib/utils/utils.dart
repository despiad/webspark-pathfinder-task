import 'package:webspark_task/domain/models/cell.dart';

sealed class Utils {
  static String formatPath(List<Cell> path) {
    return path
        .map(
          (e) => '(${e.x},${e.y})',
        )
        .join('->')
        .toString();
  }
}
