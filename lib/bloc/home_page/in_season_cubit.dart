import 'package:bloc/bloc.dart';
import 'package:gardener/constants/enums.dart';
import 'package:gardener/services/firestore.dart';
import 'package:meta/meta.dart';

import '../../models/plant_data.dart';

part 'in_season_state.dart';

class InSeasonCubit extends Cubit<InSeasonState> {
  InSeasonCubit() : super(InSeasonInitial());

  Future loadSeasonPlants() async {
    emit(InSeasonLoading());

    List<PlantData> plants = await FirestoreService().getPlants().first;
    int currentSeason = DateTime.now().month * 2 + DateTime.now().day ~/ 15;
    print(currentSeason);
    emit(InSeasonLoaded(plants
        .where((PlantData plant) =>
            plant.seasons.elementAt(currentSeason) == Seasons.growing ||
            plant.seasons.elementAt(currentSeason) == Seasons.planting)
        .toList()
        .sublist(0, 1)));
  }
}
