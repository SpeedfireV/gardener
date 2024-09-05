part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

class SearchAddMorePlants extends SearchEvent {

}

class SearchQueryChanged extends SearchEvent {
  final String query;

  SearchQueryChanged(this.query);
}

class SearchFilterChanged extends SearchEvent {
  final PlantType filter;

  SearchFilterChanged(this.filter);
}

class SearchSortingChanged extends SearchEvent {
  final SortingDirection sortingDirection;

  SearchSortingChanged(this.sortingDirection);
}

class SearchCardClicked extends SearchEvent {
  final String latin;

  SearchCardClicked(this.latin);
}
