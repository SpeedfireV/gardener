import 'package:flutter/material.dart';
import 'package:gardener/constants/colors.dart';

enum SortingDirection { ascending, descending }

enum Seasons { planting, growing, harvesting, resting }

enum PlantType { all("All"), vegetable("Vegetables"), fruit("Fruits"), herb("Herbs");
  final String name;
  const PlantType(this.name);
}

enum IsPlantGrown { grown, notGrown, unknown }

enum CombinationStatus {
  worstCombination,
  badCombination,
  selected,
  goodCombination,
  bestCombination
}

String combinationStatusToString(CombinationStatus combinationStatus) {
  switch (combinationStatus) {
    case CombinationStatus.worstCombination:
      {
        return "Really Bad Combination";
      }
    case CombinationStatus.badCombination:
      {
        return "Bad Combination";
      }
    case CombinationStatus.selected:
      {
        return "Already Selected";
      }
    case CombinationStatus.goodCombination:
      {
        return "Good Combination";
      }
    case CombinationStatus.bestCombination:
      {
        return "Great Combination";
      }
  }
}

Color combinationStatusToColor(CombinationStatus? combinationStatus) {
  if (combinationStatus == CombinationStatus.worstCombination ||
      combinationStatus == CombinationStatus.badCombination) {
    return ColorPalette.complementaryColor;
  } else if (combinationStatus == CombinationStatus.goodCombination ||
      combinationStatus == CombinationStatus.bestCombination) {
    return ColorPalette.primaryColor;
  } else {
    return ColorPalette.primaryTextColor;
  }
}

IconData combinationStatusToIconData(CombinationStatus? combinationStatus) {
  switch (combinationStatus) {
    case CombinationStatus.worstCombination:
      {
        return Icons.keyboard_double_arrow_down_rounded;
      }
    case CombinationStatus.badCombination:
      {
        return Icons.keyboard_arrow_down_rounded;
      }

    case CombinationStatus.goodCombination:
      {
        return Icons.keyboard_arrow_up_rounded;
      }
    case CombinationStatus.bestCombination:
      {
        return Icons.keyboard_double_arrow_up_rounded;
      }
    default:
      return Icons.remove_rounded;
  }
}
