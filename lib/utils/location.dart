import 'dart:ui' as ui;

import '../constants/enums.dart';
import '../models/plant_data.dart';

String? getCountryCode() {
  return ui.PlatformDispatcher.instance.locale.countryCode;
}

IsPlantGrown isPlantGrown(PlantData plant) {
  IsPlantGrown? grownInUserCountry;
  String? userCountryCode = getCountryCode();

  print(userCountryCode);
  print(plant.countries);
  if (userCountryCode != null) {
    if (
        plant.countries.containsKey(userCountryCode.toUpperCase())) {
      if (plant.countries[userCountryCode] == true) {
        grownInUserCountry = IsPlantGrown.grown;
      } else if (plant.countries[userCountryCode] == false) {
        grownInUserCountry = IsPlantGrown.notGrown;
      } else {
        grownInUserCountry = IsPlantGrown.unknown;
      }
    } else {
      grownInUserCountry = IsPlantGrown.unknown;
    }
  } else {
    grownInUserCountry = IsPlantGrown.unknown;
  }
  return grownInUserCountry;
}
