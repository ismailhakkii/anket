import 'package:get_it/get_it.dart';

// Survey feature
import 'features/survey/data/repositories/survey_repository_impl.dart';
import 'features/survey/domain/repositories/survey_repository.dart';
import 'features/survey/domain/usecases/get_surveys.dart';
import 'features/survey/domain/usecases/save_survey.dart';
import 'features/survey/presentation/bloc/survey_bloc.dart';
import 'features/survey/presentation/bloc/create_survey_bloc.dart';

// Decision feature
import 'features/decision/data/repositories/decision_repository_impl.dart';
import 'features/decision/domain/repositories/decision_repository.dart';
import 'features/decision/domain/usecases/spin_decision.dart';
import 'features/decision/domain/usecases/get_decision_options.dart';
import 'features/decision/domain/usecases/save_decision_options.dart';
import 'features/decision/presentation/bloc/decision_bloc.dart';
import 'features/decision/presentation/bloc/create_decision_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Survey
  sl.registerLazySingleton<SurveyRepository>(() => SurveyRepositoryImpl());
  sl.registerLazySingleton(() => GetSurveys(sl()));
  sl.registerLazySingleton(() => SaveSurvey(sl()));
  sl.registerFactory(() => SurveyBloc(sl()));
  sl.registerFactory(() => CreateSurveyBloc(sl()));

  // Decision
  sl.registerLazySingleton<DecisionRepository>(() => DecisionRepositoryImpl());
  sl.registerLazySingleton(() => GetDecisionOptions(sl()));
  sl.registerLazySingleton(() => SaveDecisionOptions(sl()));
  sl.registerLazySingleton(() => SpinDecision(sl()));
  sl.registerFactory(() => DecisionBloc(sl(), sl()));
  sl.registerFactory(() => CreateDecisionBloc(sl()));

  // Decision configuration future registrations
  // e.g. sl.registerLazySingleton(() => SaveDecisionWheel(sl()));
  // sl.registerFactory(() => CreateDecisionBloc(sl()));
}