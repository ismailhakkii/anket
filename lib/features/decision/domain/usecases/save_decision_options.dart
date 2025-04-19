import '../repositories/decision_repository.dart';

class SaveDecisionOptions {
  final DecisionRepository repository;

  SaveDecisionOptions(this.repository);

  Future<void> call(List<String> options) async {
    return repository.saveOptions(options);
  }
}