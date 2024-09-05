import 'package:bloc/bloc.dart';
import 'package:gardener/constants/enums.dart';
import 'package:meta/meta.dart';

import '../../models/plant_data.dart';

part 'in_season_state.dart';

class InSeasonCubit extends Cubit<InSeasonState> {
  InSeasonCubit() : super(InSeasonInitial());

  Future loadSeasonPlants() async {
    emit(InSeasonLoading());

    List<PlantData> plants = [];
    int currentSeason = DateTime.now().month * 2 + DateTime.now().day ~/ 15;
    print(currentSeason);
    Iterable<PlantData> filteredPlants = plants
        .where((PlantData plant) =>
            plant.seasons.elementAt(currentSeason) == Seasons.growing ||
            plant.seasons.elementAt(currentSeason) == Seasons.planting)
        .toList();
    if (filteredPlants.length > 2) {
      filteredPlants = [
        filteredPlants.elementAt(0),
        filteredPlants.elementAt(1)
      ];
    }
    emit(InSeasonLoaded(filteredPlants));
  }
}
