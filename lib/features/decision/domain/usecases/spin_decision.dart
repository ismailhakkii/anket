import 'dart:math';
import '../entities/decision_result.dart';
import 'get_decision_options.dart';

class SpinDecision {
  final GetDecisionOptions getOptions;

  SpinDecision(this.getOptions);

  Future<DecisionResult> call() async {
    final options = await getOptions();
    final randomIndex = Random().nextInt(options.length);
    return DecisionResult(options: options, selectedIndex: randomIndex);
  }
}