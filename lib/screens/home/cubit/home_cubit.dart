import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:webspark_task/domain/repo/data_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final DataRepository _dataRepository;

  HomeCubit({required DataRepository dataRepository})
      : _dataRepository = dataRepository,
        super(
          const HomeState(
            error: "",
            loading: false,
            success: false,
          ),
        );

  FutureOr<void> homeButtonPressed(String url) async {
    emit(HomeState.loading());
    // check url
    try {
      final supportsGet = await _dataRepository.checkUrlMethods(url);
      if (!supportsGet) {
        emit(HomeState.error('URL does not allow GET method'));
        return;
      }
    } on Exception catch (e) {
      emit(HomeState.error(e.toString()));
      return;
    }

    emit(HomeState.success());
  }
}
