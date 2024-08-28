part of 'in_season_cubit.dart';

@immutable
sealed class InSeasonState {}

final class InSeasonInitial extends InSeasonState {}

final class InSeasonLoading extends InSeasonState {}

final class InSeasonLoaded extends InSeasonState {
  final Iterable<PlantData> plants;

  InSeasonLoaded(this.plants);
}
