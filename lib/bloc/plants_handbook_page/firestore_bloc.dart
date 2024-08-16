import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../models/plant_data.dart';
import '../../services/firestore.dart';

part 'firestore_event.dart';
part 'firestore_state.dart';

class FirestoreBloc extends Bloc<FirestoreEvent, FirestoreState> {
  final FirestoreService _firestoreService;
  Iterable<PlantData> allPlants = [];
  Iterable<PlantData> filteredPlants = [];
  FirestoreBloc(this._firestoreService) : super(FirestoreInitial()) {
    on<LoadPlants>(
      (event, emit) async {
        try {
          emit(PlantsLoading());
          final List<PlantData> plants =
              await _firestoreService.getPlants().first;
          debugPrint("Plants:\n$plants");
          allPlants = plants;
          filteredPlants = plants;
          emit(PlantsLoaded(plants));
        } catch (e) {
          emit(PlantsError(e.toString()));
        }
      },
    );
  }

  @override
  void onChange(Change<FirestoreState> change) {
    super.onChange(change);
    print(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    print(error);
    print(stackTrace);
  }
}
