part of 'firestore_bloc.dart';

@immutable
sealed class FirestoreEvent {}

class LoadPlants extends FirestoreEvent {
  LoadPlants();
}

class FilterPlants extends FirestoreEvent {
  final String query;

  FilterPlants(this.query);
}
