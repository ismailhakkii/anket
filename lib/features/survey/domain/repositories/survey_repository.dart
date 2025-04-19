import 'package:anket/features/survey/domain/entities/survey.dart';

abstract class SurveyRepository {
  Future<List<Survey>> getSurveys();
  Future<void> saveSurvey(Survey survey);
}
