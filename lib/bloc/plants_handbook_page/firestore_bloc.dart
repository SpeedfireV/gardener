import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gardener/constants/enums.dart';

import '../../models/plant_data.dart';
import '../../services/firestore.dart';

part 'firestore_event.dart';
part 'firestore_state.dart';

class FirestoreBloc extends Bloc<FirestoreEvent, FirestoreState> {
  final FirestoreService _firestoreService;
  List<PlantData> allPlants = [];
  DocumentSnapshot? lastFetchedDoc;
  FirestoreBloc(this._firestoreService) : super(FirestoreInitial()) {
    on<LoadPlants>(
      (event, emit) async {
        try {
          emit(PlantsLoading());
          if (event.changedFilters == true) {
            allPlants = [];
          }
          final List<PlantData>? plants = await _firestoreService.getPlants(
              sortingDirection: event.sortingDirection,
              changedFilters: event.changedFilters,
              filter: event.filter,
              query: event.query);

          debugPrint("Plants:\n$plants");
          if (plants != null) {
            allPlants.addAll(plants);
          }

          emit(PlantsLoaded(allPlants));
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
