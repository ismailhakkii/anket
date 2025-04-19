abstract class DecisionRepository {
  Future<List<String>> getOptions();
  Future<void> saveOptions(List<String> options);
}
