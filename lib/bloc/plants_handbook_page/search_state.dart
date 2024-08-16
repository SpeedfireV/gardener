part of 'search_bloc.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

class SearchFiltered extends SearchState {
  final Iterable<PlantData> filteredPlants;
  SearchFiltered(this.filteredPlants);
}

class SearchError extends SearchState {
  final String errorMessage;

  SearchError(this.errorMessage);
}

class SearchFiltering extends SearchState {}

class SearchSorting extends SearchState {}

class SearchCardExpanding extends SearchState {}
