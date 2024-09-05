import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../models/plant_data.dart';
import '../../services/firestore.dart';

part 'firestore_event.dart';
part 'firestore_state.dart';

class FirestoreBloc extends Bloc<FirestoreEvent, FirestoreState> {
  final FirestoreService _firestoreService;
  List<PlantData> allPlants = [];
  FirestoreBloc(this._firestoreService) : super(FirestoreInitial()) {
    on<LoadPlants>(
      (event, emit) async {
        print("Current Plants:");
        print(allPlants);
        emit(PlantsLoading());
        try {
          if (allPlants.isEmpty) {
            print("Fetching Firebase Data");
            final List<PlantData> plants =
                await _firestoreService.getPlants().first;

            debugPrint("Plants:\n$plants");
            allPlants = plants;
          }
        } catch (e) {
          emit(PlantsError(e.toString()));
        }
        emit(PlantsLoaded(allPlants));
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
