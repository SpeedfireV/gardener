part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

class SearchQueryChanged extends SearchEvent {
  final String query;

  SearchQueryChanged(this.query);
}

class FilterChanged extends SearchEvent {
  final PlantType filter;

  FilterChanged(this.filter);
}

class SortingChanged extends SearchEvent {
  final SortingDirection sortingDirection;

  SortingChanged(this.sortingDirection);
}

enum SortingDirection { ascending, descending }
