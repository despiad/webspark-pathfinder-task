import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:webspark_task/domain/models/solution.dart';
import 'package:webspark_task/domain/repo/data_repo.dart';

part 'solution_list_state.dart';

class SolutionListCubit extends Cubit<SolutionListState> {
  final DataRepository _dataRepository;

  SolutionListCubit({required DataRepository dataRepository})
      : _dataRepository = dataRepository,
        super(const SolutionListState());

  Future<void> getSolutions() async {
    final solutions = await _dataRepository.getSolutions();
    emit(SolutionListState(solutions: solutions));
  }

  Future<void> reload() async {
    final solutions = await _dataRepository.loadInCache();
    emit(SolutionListState(solutions: solutions));
  }
}
