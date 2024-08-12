import 'package:json_annotation/json_annotation.dart';

import 'min_max_values.dart';

part "plant_data.g.dart";

@JsonSerializable()
class PlantData {
  final String name;
  final String latin;
  final String description;
  final MinMaxValues growingTime;
  final bool grown;
  final MinMaxValues optimalTemp;
  final int growingDifficulty;
  final MinMaxValues airHumidity;
  final List<Seasons> seasons;
  final int neededWater;
  final int neededLight;
  final String howToPlant;
  PlantData(
      this.name,
      this.latin,
      this.description,
      this.growingTime,
      this.grown,
      this.optimalTemp,
      this.growingDifficulty,
      this.airHumidity,
      this.seasons,
      this.neededWater,
      this.neededLight,
      this.howToPlant);

  factory PlantData.fromJson(Map<String, dynamic> json) =>
      _$PlantDataFromJson(json);
}

enum Seasons { planting, growing, harvesting, resting }
