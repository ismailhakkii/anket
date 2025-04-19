import 'package:get_it/get_it.dart';

// Survey feature
import 'features/survey/data/repositories/survey_repository_impl.dart';
import 'features/survey/domain/repositories/survey_repository.dart';
import 'features/survey/domain/usecases/get_surveys.dart';
import 'features/survey/presentation/bloc/survey_bloc.dart';

// Decision feature
import 'features/decision/data/repositories/decision_repository_impl.dart';
import 'features/decision/domain/repositories/decision_repository.dart';
import 'features/decision/domain/usecases/spin_decision.dart';
import 'features/decision/domain/usecases/get_decision_options.dart';
import 'features/decision/presentation/bloc/decision_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Survey
  sl.registerLazySingleton<SurveyRepository>(() => SurveyRepositoryImpl());
  sl.registerLazySingleton(() => GetSurveys(sl()));
  sl.registerFactory(() => SurveyBloc(sl()));

  // Decision
  sl.registerLazySingleton<DecisionRepository>(() => DecisionRepositoryImpl());
  sl.registerLazySingleton(() => GetDecisionOptions(sl()));
  sl.registerLazySingleton(() => SpinDecision(sl()));
  sl.registerFactory(() => DecisionBloc(sl(), sl()));
}