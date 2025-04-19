import 'package:equatable/equatable.dart';

enum CreateSurveyStatus { initial, submitting, success, failure }

class CreateSurveyState extends Equatable {
  final String question;
  final List<String> options;
  final CreateSurveyStatus status;

  const CreateSurveyState({required this.question, required this.options, required this.status});

  factory CreateSurveyState.initial() {
    return const CreateSurveyState(
      question: '',
      options: [''],
      status: CreateSurveyStatus.initial,
    );
  }

  bool get isValid => question.isNotEmpty && options.isNotEmpty && options.every((o) => o.isNotEmpty);

  CreateSurveyState copyWith({String? question, List<String>? options, CreateSurveyStatus? status}) {
    return CreateSurveyState(
      question: question ?? this.question,
      options: options ?? this.options,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [question, options, status];
  }
