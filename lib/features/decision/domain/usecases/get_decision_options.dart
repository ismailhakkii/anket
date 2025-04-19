import '../repositories/decision_repository.dart';

class GetDecisionOptions {
  final DecisionRepository repository;

  GetDecisionOptions(this.repository);

  Future<List<String>> call() async {
    return await repository.getOptions();
  }
}