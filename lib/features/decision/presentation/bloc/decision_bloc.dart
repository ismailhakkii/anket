import 'package:anket/features/decision/domain/entities/decision_result.dart';
import 'package:anket/features/decision/domain/usecases/get_decision_options.dart';
import 'package:anket/features/decision/domain/usecases/spin_decision.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'decision_event.dart';
part 'decision_state.dart';

class DecisionBloc extends Bloc<DecisionEvent, DecisionState> {
  final GetDecisionOptions getOptions;
  final SpinDecision spinDecision;

  DecisionBloc(this.getOptions, this.spinDecision) : super(DecisionInitial()) {
    on<LoadOptions>((event, emit) async {
      emit(DecisionLoadingOptions());
      try {
        final options = await getOptions();
        emit(DecisionOptionsLoaded(options));
      } catch (_) {
        emit(const DecisionError('Seçenekler yüklenirken hata oluştu.'));
      }
    });

    on<SpinDecisionEvent>((event, emit) async {
      emit(DecisionSpinning());
      try {
        final result = await spinDecision();
        emit(DecisionSpun(result));
      } catch (_) {
        emit(const DecisionError('Karar çarkı döndürülürken hata oluştu.'));
      }
    });
  }
}