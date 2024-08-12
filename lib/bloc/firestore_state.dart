part of 'firestore_bloc.dart';

@immutable
abstract class FirestoreState {}

final class FirestoreInitial extends FirestoreState {}

class PlantsLoading extends FirestoreState {}

class PlantsLoaded extends FirestoreState {
  final List<PlantData> plants;
  PlantsLoaded(this.plants);
}

class PlantsError extends FirestoreState {
  final String errorMessage;
  PlantsError(this.errorMessage);
}
