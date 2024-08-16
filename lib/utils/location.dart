import 'dart:ui' as ui;

import '../models/plant_data.dart';

String? getCountryCode() {
  return ui.PlatformDispatcher.instance.locale.countryCode;
}

IsPlantGrown isPlantGrown(PlantData plant) {
  IsPlantGrown? grownInUserCountry;
  String? userCountryCode = getCountryCode();
  if (userCountryCode != null) {
    if (plant.countries.containsKey(userCountryCode)) {
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

enum IsPlantGrown { grown, notGrown, unknown }
