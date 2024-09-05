import 'package:bloc/bloc.dart';

class ScrollCubit extends Cubit<double> {
  ScrollCubit() : super(0);
  void checkOffset(double offset) {
    print("Current Scroll Offset is $offset");
    emit(offset);
  }
}

enum ScrollPosition { atTheTop, inTheMiddle, atTheBottom }
