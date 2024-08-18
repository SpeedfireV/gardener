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
