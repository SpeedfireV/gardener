part of 'firestore_bloc.dart';

@immutable
sealed class FirestoreEvent {}

class LoadPlants extends FirestoreEvent {}
