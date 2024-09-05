part of 'in_season_cubit.dart';

@immutable
sealed class InSeasonState {}

final class InSeasonInitial extends InSeasonState {}

final class InSeasonLoading extends InSeasonState {}

final class InSeasonSpecialPlantsLoaded extends InSeasonState {
  final Iterable<PlantData> inSeasonPlants;
  final Iterable<PlantData> fruits;
  final Iterable<PlantData> vegetables;
  final Iterable<PlantData> herbs;

  InSeasonSpecialPlantsLoaded(
      {required this.inSeasonPlants,
      required this.fruits,
      required this.vegetables,
      required this.herbs});
}
