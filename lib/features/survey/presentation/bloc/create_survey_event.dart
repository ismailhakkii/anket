import 'package:equatable/equatable.dart';

abstract class CreateSurveyEvent extends Equatable {
  const CreateSurveyEvent();

  @override
  List<Object?> get props => [];
}

class QuestionChanged extends CreateSurveyEvent {
  final String question;
  const QuestionChanged(this.question);

  @override
  List<Object?> get props => [question];
}

class OptionChanged extends CreateSurveyEvent {
  final int index;
  final String option;
  const OptionChanged(this.index, this.option);

  @override
  List<Object?> get props => [index, option];
}

class AddOption extends CreateSurveyEvent {}

class RemoveOption extends CreateSurveyEvent {
  final int index;
  const RemoveOption(this.index);

  @override
  List<Object?> get props => [index];
}

class SubmitSurvey extends CreateSurveyEvent {}