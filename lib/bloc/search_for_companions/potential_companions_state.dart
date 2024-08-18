part of 'potential_companions_bloc.dart';

@immutable
sealed class PotentialCompanionsState {}

final class PotentialCompanionsInitial extends PotentialCompanionsState {}

class PotentialCompanionsLoaded extends PotentialCompanionsState {
  final String gptResponse;

  PotentialCompanionsLoaded(this.gptResponse);
}

class PotentialCompanionsSearchingForCompanions
    extends PotentialCompanionsState {}
