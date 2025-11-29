import 'package:equatable/equatable.dart';

/// View state for handling loading, error, and data states
enum ViewState { initial, loading, hasData, noData, error }

/// Generic wrapper for handling view states with data
///
/// Used to manage loading, error, and success states in a type-safe manner.
///
/// Example usage:
/// ```dart
/// class HomeState {
///   final ViewData<List<Pokemon>> pokemonsLoadData;
///   // ...
/// }
///
/// // In Cubit
/// emit(state.copyWith(pokemonsLoadData: ViewData.loading()));
/// try {
///   final pokemons = await repository.getPokemons();
///   emit(state.copyWith(pokemonsLoadData: ViewData.loaded(data: pokemons)));
/// } catch (e) {
///   emit(state.copyWith(pokemonsLoadData: ViewData.error(message: e.toString())));
/// }
/// ```
class ViewData<T> extends Equatable {
  final ViewState status;
  final T? data;
  final String message;

  const ViewData._({required this.status, this.data, this.message = ''});

  /// Create initial state
  factory ViewData.initial() => const ViewData._(status: ViewState.initial);

  /// Create loading state
  factory ViewData.loading({String? message}) =>
      ViewData._(status: ViewState.loading, message: message ?? '');

  /// Create loaded state with data
  factory ViewData.loaded({T? data}) =>
      ViewData._(status: ViewState.hasData, data: data);

  /// Create error state
  factory ViewData.error({String? message, T? data}) => ViewData._(
    status: ViewState.error,
    message: message ?? 'An error occurred',
    data: data,
  );

  /// Create no data state
  factory ViewData.noData({required String message}) =>
      ViewData._(status: ViewState.noData, message: message);

  /// Check if currently in loading state
  bool get isLoading => status == ViewState.loading;

  /// Check if currently in error state
  bool get isError => status == ViewState.error;

  /// Check if currently has data
  bool get isHasData => status == ViewState.hasData;

  /// Check if currently has no data
  bool get isNoData => status == ViewState.noData;

  /// Check if currently in initial state
  bool get isInitial => status == ViewState.initial;

  /// Copy with new values
  ViewData<T> copyWith({ViewState? status, T? data, String? message}) {
    return ViewData._(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, data, message];
}
