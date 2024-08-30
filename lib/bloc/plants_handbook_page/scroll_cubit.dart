import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';


class ScrollCubit extends Cubit<bool> {
  ScrollCubit() : super(false);
  void checkOffset(double offset) {
    print("Current Scroll Offset is $offset");
    if (offset > 200) {
      print("Offset greater than 200");
      emit(true);
    } else {
      emit(false);
    }
  }
}
