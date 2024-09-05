part of 'firestore_bloc.dart';

@immutable
abstract class FirestoreState {}

class FirestoreInitial extends FirestoreState {}

class PlantsLoading extends FirestoreState {}

class PlantsLoaded extends FirestoreState {
  final List<PlantData> plants;

  PlantsLoaded(this.plants) {
    print("Loaded $plants");
  }
}

class PlantsFiltered extends FirestoreState {
  final Iterable<PlantData> plants;

  PlantsFiltered(this.plants);
}

class PlantsError extends FirestoreState {
  final String errorMessage;
  PlantsError(this.errorMessage);
}
