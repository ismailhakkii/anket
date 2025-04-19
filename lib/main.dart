import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;  // Service locator
import 'features/survey/presentation/bloc/survey_bloc.dart';
import 'features/decision/presentation/bloc/decision_bloc.dart';
import 'presentation/pages/home_page.dart';
import 'features/survey/presentation/pages/survey_page.dart';
import 'features/decision/presentation/pages/decision_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<SurveyBloc>()),
        BlocProvider(create: (_) => di.sl<DecisionBloc>()),
      ],
      child: MaterialApp(
        title: 'Anket & Karar Uygulaması',
        theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        initialRoute: '/',
        routes: {
          '/': (_) => const HomePage(),
          '/survey': (_) => const SurveyPage(),
          '/decision': (_) => const DecisionPage(),
        },
      ),
    );
  }
}

// Note: Create HomePage, SurveyPa ge, and DecisionPage in features/.../presentation/pages
