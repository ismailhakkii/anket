

part of 'decision_bloc.dart';



abstract class DecisionState extends Equatable {
  const DecisionState();

  @override
  List<Object?> get props => [];
}

class DecisionInitial extends DecisionState {}

class DecisionLoadingOptions extends DecisionState {}

class DecisionOptionsLoaded extends DecisionState {
  final List<String> options;
  const DecisionOptionsLoaded(this.options);

  @override
  List<Object?> get props => [options];
}

class DecisionSpinning extends DecisionState {}

class DecisionSpun extends DecisionState {
  final DecisionResult result;
  const DecisionSpun(this.result);

  @override
  List<Object?> get props => [result];
}

class DecisionError extends DecisionState {
  final String message;
  const DecisionError(this.message);

  @override
  List<Object?> get props => [message];
}