import '../../domain/entities/survey.dart';
import '../../domain/repositories/survey_repository.dart';

class SurveyRepositoryImpl implements SurveyRepository {
  @override
  Future<List<Survey>> getSurveys() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      Survey(
        id: '1',
        question: 'Flutter geliştirmeyi seviyor musunuz?',
        options: ['Evet', 'Hayır', 'Kararsızım'],
      ),
      Survey(
        id: '2',
        question: 'Hangi mobil platform?',
        options: ['Android', 'iOS', 'Her ikisi'],
      ),
    ];
  }
}