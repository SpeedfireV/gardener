part of 'potential_companions_bloc.dart';

@immutable
sealed class PotentialCompanionsEvent {}

class PotentialCompanionsFindCompanions extends PotentialCompanionsEvent {
  final Iterable<PlantData> plants;

  PotentialCompanionsFindCompanions(this.plants);
}
