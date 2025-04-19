part of 'decision_bloc.dart';

abstract class DecisionEvent extends Equatable {
  const DecisionEvent();

  @override
  List<Object?> get props => [];
}

class LoadOptions extends DecisionEvent {}

class SpinDecisionEvent extends DecisionEvent {}