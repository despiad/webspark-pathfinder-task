import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:webspark_task/domain/models/task.dart';
import 'package:webspark_task/domain/models/solution.dart';
import 'package:webspark_task/domain/repo/data_repo.dart';
import 'package:webspark_task/resources/strings.dart';

part 'process_state.dart';

class ProcessCubit extends Cubit<ProcessState> {
  final DataRepository _dataRepository;

  ProcessCubit({required DataRepository dataRepository})
      : _dataRepository = dataRepository,
        super(const FetchingState(percents: 0));

  FutureOr<void> getAndProcessGrids(String url) async {
    try {
      final grids = await _dataRepository.getGrids(url);
      emit(ProcessIsRunningState(grids: grids, percents: 20));
      final percentPerGrid = 80 ~/ grids.length;

      List<Solution> solutions = List.empty(growable: true);

      for (var grid in grids) {
        // add sleeping to show process slowly
        await Future.delayed(const Duration(seconds: 1));
        final path = _dataRepository.search(grid.grid, grid.start, grid.end);
        solutions.add(Solution(task: grid, path: path));
        emit(ProcessIsRunningState(
            grids: grids, percents: state.percents + percentPerGrid));
      }
      emit(SuccessProcessState(
          solutions: solutions, grids: grids, percents: 100));
    } on Exception catch (e) {
      emit(ErrorFetchingState(err: e.toString(), percents: 0));
    }
  }

  FutureOr<void> sendSolutions(String url) async {
    assert(state is ProcessingFinishedState);

    final curState = (state as ProcessingFinishedState);
    emit(SendingResultsState(
        solutions: curState.solutions,
        percents: curState.percents,
        grids: curState.grids));
    try {
      // await _dataRepository.sendResults(url, curState.solutions);
      await _dataRepository.saveSolutions(curState.solutions);
      emit(SuccessSendingResultsState(
        solutions: curState.solutions,
        percents: curState.percents,
        grids: curState.grids,
      ));
    } catch (e) {
      emit(ErrorSendingResultsState(
        err: e.toString(),
        percents: 100,
        solutions: curState.solutions,
        grids: curState.grids,
      ));
    }
  }
}
