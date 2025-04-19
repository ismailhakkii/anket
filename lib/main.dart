import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;  // Service locator
import 'features/survey/presentation/bloc/survey_bloc.dart';
import 'features/decision/presentation/bloc/decision_bloc.dart';
import 'presentation/pages/home_page.dart';
import 'features/survey/presentation/pages/survey_page.dart';
import 'features/decision/presentation/pages/decision_page.dart';
import 'features/survey/presentation/pages/create_survey_page.dart';
import 'features/decision/presentation/pages/create_decision_page.dart';
import 'features/survey/presentation/bloc/create_survey_bloc.dart';
import 'features/decision/presentation/bloc/create_decision_bloc.dart';

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
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            primary: Colors.deepPurple,
            secondary: Colors.pinkAccent,
          ),
          scaffoldBackgroundColor: Colors.grey[50],
          cardTheme: CardTheme(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              backgroundColor: Colors.pinkAccent,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => const HomePage(),
          '/survey': (_) => const SurveyPage(),
          '/decision': (_) => const DecisionPage(),
          '/create_survey': (_) => BlocProvider(
              create: (_) => di.sl<CreateSurveyBloc>(), child: const CreateSurveyPage()),
          '/create_decision': (_) => BlocProvider(
              create: (_) => di.sl<CreateDecisionBloc>(), child: const CreateDecisionPage()),
        },
      ),
    );
  }
}

// Note: Create HomePage, SurveyPage, and DecisionPage in features/.../presentation/pages
