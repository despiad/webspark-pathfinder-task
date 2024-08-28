part of 'process_cubit.dart';

@immutable
abstract class ProcessState {
  final int percents;

  const ProcessState({required this.percents});

  bool get fetching {
    return switch (this) {
      NotLoadedState _ => true,
      _ => false,
    };
  }

  bool get processing {
    return switch (this) {
      ProcessIsRunningState _ => true,
      SuccessSendingResultsState _ => true,
      _ => false,
    };
  }

  String? get error {
    return switch (this) {
      ErrorFetchingState s => s.err,
      ErrorSendingResultsState s => s.err,
      _ => null,
    };
  }

  bool get isError => error != null;

  String get statusText {
    return switch (this) {
      ErrorFetchingState s => s.err,
      ErrorSendingResultsState s => s.err,
      SuccessProcessState _ => Strings.processSuccessState,
      NotLoadedState _ => Strings.processFetchingState,
      LoadedState _ => Strings.processLoadingState,
      _ => "",
    };
  }

  bool get disableButton {
    return switch (this) {
      ProcessingFinishedState s when s is SendingResultsState => true,
      ProcessingFinishedState _ => false,
      NotLoadedState _ => true,
      LoadedState _ => true,
      _ => true,
    };
  }
}

@immutable
abstract class NotLoadedState extends ProcessState {
  const NotLoadedState({required super.percents});
}

abstract class LoadedState extends ProcessState {
  final List<Task> grids;

  const LoadedState({required this.grids, required super.percents});
}

abstract class ProcessingFinishedState extends LoadedState {
  final List<Solution> solutions;

  const ProcessingFinishedState({
    required this.solutions,
    required super.percents,
    required super.grids,
  });
}

final class FetchingState extends NotLoadedState {
  const FetchingState({required super.percents});
}

final class ErrorFetchingState extends NotLoadedState {
  final String err;

  const ErrorFetchingState({required this.err, required super.percents});
}

final class ProcessIsRunningState extends LoadedState {
  const ProcessIsRunningState({required super.grids, required super.percents});
}

final class SuccessProcessState extends ProcessingFinishedState {
  const SuccessProcessState({
    required super.solutions,
    required super.percents,
    required super.grids,
  });
}

final class SendingResultsState extends ProcessingFinishedState {
  const SendingResultsState({
    required super.solutions,
    required super.percents,
    required super.grids,
  });
}

final class ErrorSendingResultsState extends ProcessingFinishedState {
  final String err;

  const ErrorSendingResultsState({
    required this.err,
    required super.percents,
    required super.solutions,
    required super.grids,
  });
}

final class SuccessSendingResultsState extends ProcessingFinishedState {
  const SuccessSendingResultsState({
    required super.solutions,
    required super.percents,
    required super.grids,
  });
}
