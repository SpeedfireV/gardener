import 'package:json_annotation/json_annotation.dart';

import 'min_max_values.dart';

part "plant_data.g.dart";

@JsonSerializable()
class PlantData {
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
      this.howToPlant);

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
      print("Assertions passed");
      return _$PlantDataFromJson(json);
    } catch (e) {
      print("Error parsing JSON in PlantData: ${e}");
      print("Received JSON: $json");
      rethrow; // Re-throwing to preserve the stack trace
    }
  }

  @override
  String toString() {
    return name;
  }
}

enum Seasons { planting, growing, harvesting, resting }

enum PlantType { all, vegetable, fruit }
