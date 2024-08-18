part of 'plants_list_bloc.dart';

@immutable
sealed class PlantsListEvent {}

class PlantsListFilterChanged extends PlantsListEvent {
  final PlantType filter;

  PlantsListFilterChanged(this.filter);
}

class PlantsListSortingChanged extends PlantsListEvent {
  final SortingDirection sortingDirection;

  PlantsListSortingChanged(this.sortingDirection);
}

class PlantsListSearchQueryChanged extends PlantsListEvent {
  final String query;

  PlantsListSearchQueryChanged(this.query);
}

class PlantsListCardClicked extends PlantsListEvent {
  final String latin;

  PlantsListCardClicked(this.latin);
}

class PlantsListPlantSelected extends PlantsListEvent {
  final PlantData plantData;

  PlantsListPlantSelected(this.plantData);
}

class PlantsListPlantRemoved extends PlantsListEvent {
  final PlantData plantData;

  PlantsListPlantRemoved(this.plantData);
}

class PlantsListResetSelection extends PlantsListEvent {}
