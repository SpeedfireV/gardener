import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../constants/enums.dart';
import '../../models/plant_data.dart';

part 'plants_list_event.dart';
part 'plants_list_state.dart';

class PlantsListBloc extends Bloc<PlantsListEvent, PlantsListState> {
  String query;
  PlantType filter;
  SortingDirection sortingDirection;
  List<PlantData> plants;
  List<PlantData> selectedPlants;
  bool sorted;
  String? expanded;
  CombinationStatus? combinationStatus;

  PlantsListBloc(this.query, this.filter, this.plants, this.sortingDirection,
      this.selectedPlants,
      {this.sorted = true})
      : super(PlantsListInitial()) {
    on<PlantsListSearchQueryChanged>((event, emit) {
      emit(PlantsListSearching());
      query = event.query;
      emit(PlantsListLoaded(filterPlants(), selectedPlants));
    });
    on<PlantsListFilterChanged>((event, emit) {
      emit(PlantsListFiltering());
      filter = event.filter;
      emit(PlantsListLoaded(filterPlants(), selectedPlants));
    });
    on<PlantsListSortingChanged>((event, emit) {
      emit(PlantsListSorting());
      sortingDirection = event.sortingDirection;
      sorted = false;
      emit(PlantsListLoaded(filterPlants(), selectedPlants));
    });
    on<PlantsListPlantSelected>((event, emit) {
      emit(PlantsListAddingPlant());
      if (!selectedPlants.contains(event.plantData)) {
        selectedPlants.add(event.plantData);
      }
      checkCombinationStatus();
      emit(PlantsListLoaded(filterPlants(), selectedPlants));
    });
    on<PlantsListPlantRemoved>((event, emit) {
      emit(PlantsListRemovingPlant());
      if (selectedPlants.contains(event.plantData)) {
        selectedPlants.remove(event.plantData);
      }
      checkCombinationStatus();

      emit(PlantsListLoaded(filterPlants(), selectedPlants));
    });
    on<PlantsListCardClicked>((event, emit) {
      emit(PlantsListCardExpanding());
      if (expanded == event.latin) {
        // Card collapse on second click
        expanded = null;
      } else {
        expanded = event.latin;
      }
      emit(PlantsListLoaded(filterPlants(), selectedPlants));
    });
    on<PlantsListResetSelection>((event, emit) {
      emit(PlantsListResetting());
      resetSelection();
      emit(PlantsListLoaded(plants, selectedPlants));
    });
  }
  void checkCombinationStatus() {
    print("Checking new combination");
    if (selectedPlants.length >= 2) {
      combinationStatus = CombinationStatus.bestCombination;
    } else {
      combinationStatus = null;
    }
  }

  void resetSelection() {
    selectedPlants = [];
    combinationStatus = null;
  }

  Iterable<PlantData> filterPlants() {
    if (!sorted) {
      plants.sort((PlantData a, PlantData b) {
        if (sortingDirection == SortingDirection.ascending) {
          return a.name
              .toLowerCase()
              .codeUnitAt(0)
              .compareTo(b.name.toLowerCase().codeUnitAt(0));
        } else {
          return b.name
              .toLowerCase()
              .codeUnitAt(0)
              .compareTo(a.name.toLowerCase().codeUnitAt(0));
        }
      });
      sorted = true;
    }
    Iterable<PlantData> filteredPlants = plants;
    if (filter != PlantType.all) {
      filteredPlants =
          filteredPlants.where((PlantData plant) => plant.type == filter);
    }
    if (query != "") {
      filteredPlants = filteredPlants.where((PlantData plant) =>
          plant.name.toLowerCase().contains(query.toLowerCase()));
    }

    return filteredPlants;
  }

  void setPlants(List<PlantData> plants) {
    this.plants = plants;
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    print(error);
    print(stackTrace);
  }

  @override
  void onChange(Change<PlantsListState> change) {
    super.onChange(change);
    print(change);
  }
}
