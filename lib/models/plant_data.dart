import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../constants/enums.dart';
import 'min_max_values.dart';

part "plant_data.g.dart";

@JsonSerializable()
class PlantData extends Equatable {
  final String name;
  final String latin;
  final PlantType type;
  final String description;
  final MinMaxValues growingTime;
  final Map<String, bool> countries;
  final MinMaxValues optimalTemp;
  final int growingDifficulty;
  final MinMaxValues airHumidity;
  final List<Seasons> seasons;
  final int neededWater;
  final int neededLight;
  final String howToPlant;
  final String soilDetails;
  PlantData(
      this.name,
      this.latin,
      this.type,
      this.description,
      this.growingTime,
      this.countries,
      this.optimalTemp,
      this.growingDifficulty,
      this.airHumidity,
      this.seasons,
      this.neededWater,
      this.neededLight,
      this.howToPlant,
      this.soilDetails);

  @override
  List<Object> get props => [
        name,
        latin,
        type,
        description,
        growingTime,
        countries,
        optimalTemp,
        growingDifficulty,
        airHumidity,
        seasons,
        neededWater,
        neededLight,
        howToPlant,
        soilDetails
      ];

  factory PlantData.fromJson(Map<String, dynamic> json) {
    try {
      assert(json['name'] is String, "Expected 'name' to be a String");
      assert(json['latin'] is String, "Expected 'latin' to be a String");
      assert(json['description'] is String,
          "Expected 'description' to be a String");
      assert(json['growingTime'] is Map<String, dynamic>,
          "Expected 'growingTime' to be a Map<String, dynamic>");
      assert(json['countries'] is Map<String, dynamic>,
          "Expected 'countries' to be a Map<String, dynamic> ${json['countries'].runtimeType}");
      assert(json['optimalTemp'] is Map<String, dynamic>,
          "Expected 'optimalTemp' to be a Map<String, dynamic>");
      assert(json['growingDifficulty'] is int,
          "Expected 'growingDifficulty' to be an int");
      assert(json['airHumidity'] is Map<String, dynamic>,
          "Expected 'airHumidity' to be a Map<String, dynamic>");
      assert(json['seasons'] is List, "Expected 'seasons' to be a List");
      assert(json['neededWater'] is int, "Expected 'neededWater' to be an int");
      assert(json['neededLight'] is int, "Expected 'neededLight' to be an int");
      assert(
          json['howToPlant'] is String, "Expected 'howToPlant' to be a String");
      assert(json['soilDetails'] is String,
          "Expected 'howToPlant' to be a String");
      print("Assertions passed");
      return _$PlantDataFromJson(json);
    } catch (e) {
      print("Error parsing JSON in PlantData: ${e}");
      print("Received JSON: $json");
      rethrow; // Re-throwing to preserve the stack trace
    }
  }

  Map<String, dynamic> toJson() => _$PlantDataToJson(this);

  @override
  String toString() {
    return name;
  }
}

String? plantTypeToString(PlantType plantType) {
  switch (plantType) {
    case PlantType.vegetable:
      {
        return "Vegetable";
      }
    case PlantType.fruit:
      {
        return "Fruit";
      }
    default:
      return null;
  }
}
