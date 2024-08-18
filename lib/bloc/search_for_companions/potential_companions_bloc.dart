import 'package:bloc/bloc.dart';
import 'package:gardener/services/chat_gpt.dart';
import 'package:meta/meta.dart';

import '../../models/plant_data.dart';

part 'potential_companions_event.dart';
part 'potential_companions_state.dart';

class PotentialCompanionsBloc
    extends Bloc<PotentialCompanionsEvent, PotentialCompanionsState> {
  List<String> previousAnswers = [];
  PotentialCompanionsBloc() : super(PotentialCompanionsInitial()) {
    on<PotentialCompanionsFindCompanions>((event, emit) async {
      emit(PotentialCompanionsSearchingForCompanions());
      List<String> plantsNames = [];
      for (PlantData plantData in event.plants) {
        plantsNames.add("${plantData.name}, ${plantData.latin}");
      }
      String? gptResponse =
          await ChatGptServices().findCompanions(plantsNames, previousAnswers);
      emit(PotentialCompanionsLoaded(gptResponse));
    });
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    print(error);
    print(stackTrace);
  }

  @override
  void onChange(Change<PotentialCompanionsState> change) {
    super.onChange(change);
    print(change);
  }
}
