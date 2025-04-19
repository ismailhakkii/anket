part of 'create_decision_bloc.dart';

enum CreateDecisionStatus { initial, submitting, success, failure }

class CreateDecisionState extends Equatable {
  final List<String> options;
  final List<Color> colors;
  final CreateDecisionStatus status;

  const CreateDecisionState({required this.options, required this.colors, required this.status});

  factory CreateDecisionState.initial() {
    return CreateDecisionState(
      options: [''],
      colors: [Colors.primaries.first],
      status: CreateDecisionStatus.initial,
    );
  }

  bool get isValid => options.isNotEmpty && options.every((o) => o.isNotEmpty);

  CreateDecisionState copyWith({List<String>? options, List<Color>? colors, CreateDecisionStatus? status}) {
    return CreateDecisionState(
      options: options ?? this.options,
      colors: colors ?? this.colors,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [options, colors, status];
}