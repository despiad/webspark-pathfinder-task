import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webspark_task/di/dependencies_container.dart';
import 'package:webspark_task/di/dependencies_scope.dart';
import 'package:webspark_task/domain/models/cell.dart';
import 'package:webspark_task/resources/colors.dart';

extension MapX<K, V> on Map<K, V> {
  V getOrDefault(K k, V fallback) {
    if (containsKey(k)) {
      return this[k]!;
    }
    return fallback;
  }
}

extension IntX on int {
  /// Check if the target in range:
  ///
  /// `start <= target < end`.
  bool inRange(int start, int end) {
    return start <= this && this < end;
  }
}

extension PointMapX on Point<int> {
  Map<String, dynamic> toMap() {
    return {"x": x, "y": y};
  }
}

extension ContextX on BuildContext {
  DependenciesContainer get dependencies {
    return DependenciesScope.of(this);
  }
}

extension CellDecorationX on Cell {
  Color backgroundColor(List<Cell> path) {
    if (this == path.first) {
      return AppColors.pathStartCellColor;
    }
    if (this == path.last) {
      return AppColors.pathEndCellColor;
    }
    if (path.contains(this)) {
      return AppColors.pathCellColor;
    }
    if (blocked) {
      return AppColors.blockedCellColor;
    }
    return AppColors.emptyCellColor;
  }

  Color get textColor {
    return blocked ? Colors.white : Colors.black;
  }
}
