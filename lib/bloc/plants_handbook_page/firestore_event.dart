part of 'firestore_bloc.dart';

@immutable
sealed class FirestoreEvent {}

class LoadPlants extends FirestoreEvent {
  LoadPlants(
      {this.changedFilters,
      required this.sortingDirection,
      this.query,
      this.filter});
  final bool? changedFilters;
  final SortingDirection sortingDirection;
  final String? query;
  final PlantType? filter;
}

class FilterPlants extends FirestoreEvent {
  final String query;

  FilterPlants(this.query);
}
