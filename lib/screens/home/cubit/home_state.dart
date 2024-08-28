part of 'home_cubit.dart';

@immutable
final class HomeState {
  final String? error;
  final bool loading;
  final bool success;

  bool get isError => error?.isNotEmpty ?? false;

  const HomeState({
    this.error = "",
    this.loading = false,
    this.success = false,
  });

  factory HomeState.success() {
    return const HomeState(success: true);
  }

  factory HomeState.loading() {
    return const HomeState(loading: true);
  }

  factory HomeState.error(String err) {
    return HomeState(error: err);
  }

  @override
  String toString() {
    return 'HomeState {error: $error, loading: $loading, success: $success}';
  }
}
