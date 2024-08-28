import 'package:flutter/material.dart';
import 'package:webspark_task/domain/models/cell.dart';
import 'package:webspark_task/domain/models/solution.dart';
import 'package:webspark_task/screens/widgets/app_scaffold.dart';
import 'package:webspark_task/utils/extensions.dart';

import '../../utils/utils.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key, required this.solution});

  final Solution solution;

  @override
  Widget build(BuildContext context) {
    return PreviewView(solution: solution);
  }
}

class PreviewView extends StatelessWidget {
  const PreviewView({super.key, required this.solution});

  final Solution solution;

  @override
  Widget build(BuildContext context) {
    final flatGrid = solution.task.grid
        .expand(
          (element) => element,
        )
        .toList();
    return AppScaffold(
        appBarTitle: 'Preview screen',
        body: Column(
          children: [
            GridView.count(
              crossAxisCount: solution.task.grid.length,
              crossAxisSpacing: 0,
              shrinkWrap: true,
              children: [
                for (final cell in flatGrid)
                  CellWidget(cell: cell, path: solution.path)
              ],
            ),
            Text(Utils.formatPath(solution.path)),
          ],
        ));
  }
}

class CellWidget extends StatelessWidget {
  const CellWidget({super.key, required this.cell, required this.path});

  final Cell cell;
  final List<Cell> path;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 40, minWidth: 40),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: cell.backgroundColor(path),
        ),
        child: Center(
          child: Text(
            '(${cell.x},${cell.y})',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: cell.textColor),
          ),
        ),
      ),
    );
  }
}
