part of 'home_cubit.dart';

/// State for home page
class HomeState extends Equatable {
  final ViewData<List<Pokemon>> pokemonsLoadData;
  final List<Pokemon> pokemons;
  final List<Pokemon> filteredPokemons;
  final int offset;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final String searchQuery;

  const HomeState({
    required this.pokemonsLoadData,
    required this.pokemons,
    required this.filteredPokemons,
    required this.offset,
    required this.hasReachedMax,
    required this.isLoadingMore,
    required this.searchQuery,
  });

  HomeState copyWith({
    ViewData<List<Pokemon>>? pokemonsLoadData,
    List<Pokemon>? pokemons,
    List<Pokemon>? filteredPokemons,
    int? offset,
    bool? hasReachedMax,
    bool? isLoadingMore,
    String? searchQuery,
  }) {
    return HomeState(
      pokemonsLoadData: pokemonsLoadData ?? this.pokemonsLoadData,
      pokemons: pokemons ?? this.pokemons,
      filteredPokemons: filteredPokemons ?? this.filteredPokemons,
      offset: offset ?? this.offset,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    pokemonsLoadData,
    pokemons,
    filteredPokemons,
    offset,
    hasReachedMax,
    isLoadingMore,
    searchQuery,
  ];
}
