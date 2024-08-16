import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/plant_data.dart';
import '../plants_handbook_page/search_bloc.dart';

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

  PlantsListBloc(this.query, this.filter, this.plants, this.sortingDirection,
      this.selectedPlants,
      {this.sorted = true})
      : super(PlantsListInitial()) {
    on<PlantsListEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

enum SelectionStatus {
  greatMatch,
  goodMatch,
  selected,
  badCombination,
}
