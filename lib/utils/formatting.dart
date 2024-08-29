import 'package:gardener/models/min_max_values.dart';

import '../models/plant_data.dart';

Map<String, List<PlantData>> dividePlantsByFirstLetter(
    Iterable<PlantData> plants) {
  Map<String, List<PlantData>> dividedPlants = {};
  for (PlantData plantData in plants) {
    String firstLetter = plantData.name.substring(0, 1);
    if (dividedPlants.containsKey(firstLetter)) {
      dividedPlants[firstLetter]!.add(plantData);
    } else {
      dividedPlants[firstLetter] = [plantData];
    }
  }
  return dividedPlants;
}

String growingTimeToString(MinMaxValues growingTime) {
  late num min;
  late num max;
  if (growingTime.min ~/ 1 == growingTime.min) {
    min = growingTime.min.toInt();
  } else {
    min = growingTime.min;
  }
  if (growingTime.max ~/ 1 == growingTime.max) {
    max = growingTime.max.toInt();
  } else {
    max = growingTime.max;
  }
  if (growingTime.min >= 1 && growingTime.min != growingTime.max) {
    return "${min}-${max} weeks";
  } else if (growingTime.min >= 1 && growingTime.min == growingTime.max) {
    return "${min} weeks";
  } else {
    return "${(growingTime.min * 7).floor()}-${(growingTime.max * 7).floor()} days";
  }
}
