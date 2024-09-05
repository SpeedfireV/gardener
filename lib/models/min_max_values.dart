import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class MinMaxValues {
  final double min;
  final double max;

  const MinMaxValues(this.min, this.max);
  //     : assert(min != null, 'Min value cannot be null'),
  //       assert(max != null, 'Max value cannot be null'),
  //       assert(min is double, 'Min value must be a double'),
  //       assert(max is double, 'Max value must be a double'),
  //       assert(min <= max, 'Min value cannot be greater than Max value');

  factory MinMaxValues.fromJson(Map<String, dynamic> json) {
    try {
      // print("Assertions passed");
      return MinMaxValues(double.parse(json['min'].toString()),
          double.parse(json['max'].toString()));
    } catch (e) {
      // print("Error parsing JSON in PlantData: ${e}");
      // print("Received JSON: $json");
      rethrow; // Re-throwing to preserve the stack trace
    }
  }

  double getMin() {
    return min;
  }

  double getMax() {
    return max;
  }

  MinMaxValues toMinMax(Map<String, dynamic> mapOfValues) {
    if (mapOfValues.containsKey("min") && mapOfValues.containsKey("max")) {
      final minValue = mapOfValues["min"];
      final maxValue = mapOfValues["max"];

      // Add assertions here as well for conversion safety
      // assert(minValue is double, 'Min value must be a double');
      // assert(maxValue is double, 'Max value must be a double');

      return MinMaxValues(minValue, maxValue);
    } else {
      throw Exception("Data doesn't contain min or max value!");
    }
  }
}
