import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'presentation/theme/app_theme.dart';
import 'presentation/pages/splash_screen.dart';

// Tema durumunu yönetmek için bloc
class ThemeBloc extends Cubit<ThemeMode> {
  final SharedPreferences prefs;
  
  ThemeBloc(this.prefs) : super(ThemeMode.system) {
    final isDark = prefs.getBool('isDarkMode');
    
    if (isDark != null) {
      emit(isDark ? ThemeMode.dark : ThemeMode.light);
    }
  }
  
  void setTheme(ThemeMode mode) {
    prefs.setBool('isDarkMode', mode == ThemeMode.dark);
    emit(mode);
  }
  
  void toggleTheme() {
    if (state == ThemeMode.light) {
      setTheme(ThemeMode.dark);
    } else {
      setTheme(ThemeMode.light);
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  
  await di.init();
  
  final prefs = await SharedPreferences.getInstance();
  
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  
  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<SurveyBloc>()),
        BlocProvider(create: (_) => di.sl<DecisionBloc>()),
        BlocProvider(create: (_) => ThemeBloc(prefs)),
      ],
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Anket & Karar Uygulaması',
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            darkTheme: AppTheme.darkTheme(),
            theme: AppTheme.lightTheme(),
            initialRoute: '/splash',
            routes: {
              '/splash': (_) => const SplashScreen(),
              '/': (_) => const HomePage(),
              '/survey': (_) => const SurveyPage(),
              '/decision': (_) => const DecisionPage(),
              '/create_survey': (_) => BlocProvider(
                create: (_) => di.sl<CreateSurveyBloc>(), 
                child: const CreateSurveyPage()
              ),
              '/create_decision': (_) => BlocProvider(
                create: (_) => di.sl<CreateDecisionBloc>(), 
                child: const CreateDecisionPage()
              ),
            },
            // Sayfa geçişleri için özel animasyon
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                case '/splash':
                  return null; // Normal route kullan
                default:
                  return CustomPageTransition(
                    page: _buildRoute(settings.name, settings.arguments),
                  );
              }
            },
          );
        },
      ),
    );
  }
  
  Widget _buildRoute(String? routeName, Object? arguments) {
    // Burada router'a göre widget döndür
    switch (routeName) {
      case '/survey':
        return const SurveyPage();
      case '/decision':
        return const DecisionPage();
      case '/create_survey':
        return BlocProvider(
          create: (_) => di.sl<CreateSurveyBloc>(), 
          child: const CreateSurveyPage()
        );
      case '/create_decision':
        return BlocProvider(
          create: (_) => di.sl<CreateDecisionBloc>(), 
          child: const CreateDecisionPage()
        );
      default:
        return const HomePage();
    }
  }
}