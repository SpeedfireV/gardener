import 'package:json_annotation/json_annotation.dart';

part 'min_max_values.g.dart';

@JsonSerializable()
class MinMaxValues {
  final double min;
  final double max;

  const MinMaxValues(this.min, this.max);

  factory MinMaxValues.fromJson(Map<String, dynamic> json) =>
      _$MinMaxValuesFromJson(json);

  double getMin() {
    return min;
  }

  double getMax() {
    return max;
  }

  MinMaxValues toMinMax(Map mapOfValues) {
    if (mapOfValues.containsKey("min") && mapOfValues.containsKey("max")) {
      return MinMaxValues(mapOfValues["min"], mapOfValues["max"]);
    } else {
      throw Exception("Data doesn't contain min or max value!");
    }
  }
}
