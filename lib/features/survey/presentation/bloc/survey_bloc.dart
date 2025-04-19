// Survey BLoC implementation with Clean Architecture
import 'package:anket/features/survey/domain/entities/survey.dart';
import 'package:anket/features/survey/domain/usecases/get_surveys.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/survey.dart';
import '../../../domain/usecases/get_surveys.dart';

part 'survey_event.dart';
part 'survey_state.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  final GetSurveys getSurveys;

  SurveyBloc(this.getSurveys) : super(SurveyInitial()) {
    on<LoadSurveys>((event, emit) async {
      emit(SurveyLoading());
      try {
        final surveys = await getSurveys();
        emit(SurveyLoaded(surveys));
      } catch (_) {
        emit(const SurveyError('Anketler yüklenirken bir hata oluştu.'));
      }
    });
  }
}