import '../repositories/survey_repository.dart';
import '../entities/survey.dart';

class GetSurveys {
  final SurveyRepository repository;

  GetSurveys(this.repository);

  Future<List<Survey>> call() async {
    return await repository.getSurveys();
  }
}
