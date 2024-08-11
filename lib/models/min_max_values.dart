import 'package:json_annotation/json_annotation.dart';

part 'min_max_values.g.dart';

@JsonSerializable()
class MinMaxValues {
  final double minimum;
  final double maximum;

  const MinMaxValues(this.minimum, this.maximum);

  factory MinMaxValues.fromJson(Map<String, dynamic> json) =>
      _$MinMaxValuesFromJson(json);

  double getMin() {
    return minimum;
  }

  double getMax() {
    return maximum;
  }

  MinMaxValues toMinMax(Map mapOfValues) {
    if (mapOfValues.containsKey("min") && mapOfValues.containsKey("max")) {
      return MinMaxValues(mapOfValues["min"], mapOfValues["max"]);
    } else {
      throw Exception("Data doesn't contain min or max value!");
    }
  }
}
