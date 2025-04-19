// Implementation of DecisionRepository with dummy options
import '../../domain/repositories/decision_repository.dart';

class DecisionRepositoryImpl implements DecisionRepository {
  @override
  Future<List<String>> getOptions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      'Arabayı mu alırsın?',
      'Kahve mi çay mı?',
      'Film mi dizi mi?',
      'Yazılım mı tasarım mı?'
    ];
  }
}