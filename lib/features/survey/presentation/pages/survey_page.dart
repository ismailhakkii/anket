import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../bloc/survey_bloc.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({Key? key}) : super(key: key);

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    context.read<SurveyBloc>().add(LoadSurveys());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anketler')),
      body: BlocBuilder<SurveyBloc, SurveyState>(
        builder: (context, state) {
          if (state is SurveyLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SurveyLoaded) {
            final surveys = state.surveys;
            return AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: surveys.length,
                itemBuilder: (context, index) {
                  final survey = surveys[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 50,
                      child: FadeInAnimation(
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(survey.question, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                ...survey.options.map((opt) => RadioListTile<String>(
                                      title: Text(opt),
                                      value: opt,
                                      groupValue: selectedOption,
                                      onChanged: (value) => setState(() => selectedOption = value),
                                    )),
                                ElevatedButton(
                                  onPressed: selectedOption == null
                                      ? null
                                      : () => ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Seçiminiz: $selectedOption')), 
                                        ),
                                  child: const Text('Gönder'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          if (state is SurveyError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}