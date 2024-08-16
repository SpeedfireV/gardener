import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:gardener/models/plant_data.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  String query;
  PlantType filter;
  SortingDirection sortingDirection;
  List<PlantData> plants;
  bool sorted;
  String? expanded;
  SearchBloc(this.query, this.filter, this.plants, this.sortingDirection,
      {this.sorted = true})
      : super(SearchInitial()) {
    on<SearchQueryChanged>((event, emit) {
      try {
        query = event.query;
        emit(SearchFiltered(filterPlants()));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    });
    on<SearchFilterChanged>((event, emit) {
      emit(SearchFiltering());
      filter = event.filter;
      emit(SearchFiltered(filterPlants()));
    });
    on<SearchSortingChanged>((event, emit) {
      emit(SearchSorting());
      sorted = false;
      sortingDirection = event.sortingDirection;
      emit(SearchFiltered(filterPlants()));
    });
    on<SearchCardClicked>((event, emit) {
      emit(SearchCardExpanding());
      if (expanded == event.latin) {
        // Card collapse on second click
        expanded = null;
      } else {
        expanded = event.latin;
      }
      emit(SearchFiltered(filterPlants()));
    });
  }

  Iterable<PlantData> filterPlants() {
    if (!sorted) {
      print("BEFORE: $plants");

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
      print("AFTER: $plants");
      sorted = true;
    }
    List<PlantData> filteredPlants = plants;
    if (filter != PlantType.all) {
      filteredPlants = filteredPlants
          .where((PlantData plant) => plant.type == filter)
          .toList();
    }
    if (query != "") {
      filteredPlants = filteredPlants
          .where((PlantData plant) =>
              plant.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
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
  void onChange(Change<SearchState> change) {
    super.onChange(change);
    print(change);
  }
}
