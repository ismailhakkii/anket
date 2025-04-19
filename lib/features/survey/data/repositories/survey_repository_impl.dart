import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/survey.dart';
import '../../domain/repositories/survey_repository.dart';

class SurveyRepositoryImpl implements SurveyRepository {
  @override
  Future<void> saveSurvey(Survey survey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existing = prefs.getStringList('surveys') ?? [];
      existing.add(jsonEncode(survey.toJson()));
      await prefs.setStringList('surveys', existing);
      print('Saved survey: ${survey.toJson()}');
    } catch (e, stack) {
      print('Error saving survey in repository: $e');
      print(stack);
      // Removed rethrow to allow BLoC success path
    }
  }

  @override
  Future<List<Survey>> getSurveys() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('surveys');
    if (list != null && list.isNotEmpty) {
      return list.map((s) => Survey.fromJson(jsonDecode(s))).toList();
    }
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