import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:gardener/constants/enums.dart';

import '../../models/plant_data.dart';

part 'in_season_state.dart';

class InSeasonCubit extends Cubit<InSeasonState> {
  InSeasonCubit() : super(InSeasonInitial());

  Future loadSeasonPlants(Iterable<PlantData> plants) async {
    emit(InSeasonLoading());

    int currentSeason = DateTime.now().month * 2 + DateTime.now().day ~/ 15;
    print(currentSeason);
    List<PlantData> filteredPlants = plants
        .where((PlantData plant) =>
            plant.seasons.elementAt(currentSeason) == Seasons.growing ||
            plant.seasons.elementAt(currentSeason) == Seasons.planting)
        .toList();
    List<PlantData> inSeasonPlants = [];
    List<PlantData> selectedVegetables = [];
    List<PlantData> selectedFruits = [];
    List<PlantData> selectedHerbs = [];

    for (int i = 0; i < 4; i++) {
      int randomElementPosition = Random().nextInt(filteredPlants.length);
      inSeasonPlants.add(filteredPlants.elementAt(randomElementPosition));
      filteredPlants.removeAt(randomElementPosition);
    }
    List<PlantData> allVegetables = filteredPlants
        .where((PlantData plant) => plant.type == PlantType.vegetable)
        .toList();

    for (int i = 0; i < 2; i++) {
      int randomElementPosition = Random().nextInt(allVegetables.length);
      selectedVegetables.add(allVegetables.elementAt(randomElementPosition));
      allVegetables.removeAt(randomElementPosition);
    }
    List<PlantData> allFruits = filteredPlants
        .where((PlantData plant) => plant.type == PlantType.fruit)
        .toList();

    for (int i = 0; i < 2; i++) {
      int randomElementPosition = Random().nextInt(allFruits.length);
      selectedFruits.add(allFruits.elementAt(randomElementPosition));
      allFruits.removeAt(randomElementPosition);
    }
    List<PlantData> allHerbs = filteredPlants
        .where((PlantData plant) => plant.type == PlantType.herb)
        .toList();

    for (int i = 0; i < 2; i++) {
      int randomElementPosition = Random().nextInt(allHerbs.length);
      selectedHerbs.add(allHerbs.elementAt(randomElementPosition));
      allHerbs.removeAt(randomElementPosition);
    }
    emit(InSeasonSpecialPlantsLoaded(
        inSeasonPlants: inSeasonPlants,
        fruits: selectedFruits,
        vegetables: selectedVegetables,
        herbs: selectedHerbs));
  }
}
