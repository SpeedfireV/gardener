part of 'plants_list_bloc.dart';

@immutable
sealed class PlantsListState {}

final class PlantsListInitial extends PlantsListState {}

class PlantsListLoaded extends PlantsListState {
  final Iterable<PlantData> plants;
  final Iterable<PlantData> selectedPlants;

  PlantsListLoaded(this.plants, this.selectedPlants);
}

class PlantsListSorting extends PlantsListState {}

class PlantsListFiltering extends PlantsListState {}

class PlantsListSearching extends PlantsListState {}

class PlantsListAddingPlant extends PlantsListState {}

class PlantsListRemovingPlant extends PlantsListState {}

class PlantsListCardExpanding extends PlantsListState {}

class PlantsListResetting extends PlantsListState {}

class PlantsListError extends PlantsListState {
  final String errorMessage;

  PlantsListError(this.errorMessage);
}
