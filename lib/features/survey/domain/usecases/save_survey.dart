import '../entities/survey.dart';
import '../repositories/survey_repository.dart';

class SaveSurvey {
  final SurveyRepository repository;

  SaveSurvey(this.repository);

  Future<void> call(Survey survey) async {
    return repository.saveSurvey(survey);
  }
}