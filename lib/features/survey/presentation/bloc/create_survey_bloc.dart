import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:anket/features/survey/domain/usecases/save_survey.dart';
import 'package:anket/features/survey/domain/entities/survey.dart';
import 'create_survey_event.dart';
import 'create_survey_state.dart';

class CreateSurveyBloc extends Bloc<CreateSurveyEvent, CreateSurveyState> {
  final SaveSurvey saveSurvey;

  CreateSurveyBloc(this.saveSurvey) : super(CreateSurveyState.initial()) {
    on<QuestionChanged>((event, emit) {
      emit(state.copyWith(question: event.question));
    });

    on<OptionChanged>((event, emit) {
      final options = List<String>.from(state.options);
      options[event.index] = event.option;
      emit(state.copyWith(options: options));
    });

    on<AddOption>((event, emit) {
      final options = List<String>.from(state.options)..add('');
      emit(state.copyWith(options: options));
    });

    on<RemoveOption>((event, emit) {
      final options = List<String>.from(state.options)..removeAt(event.index);
      emit(state.copyWith(options: options));
    });

    on<SubmitSurvey>((event, emit) async {
      if (!state.isValid) return;
      emit(state.copyWith(status: CreateSurveyStatus.submitting));
      final survey = Survey(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        question: state.question,
        options: state.options,
      );
      try {
        await saveSurvey.call(survey);
        emit(state.copyWith(status: CreateSurveyStatus.success));
      } catch (_) {
        emit(state.copyWith(status: CreateSurveyStatus.failure));
      }
    });
  }
}