import 'package:anket/features/survey/presentation/bloc/create_survey_event.dart';
import 'package:anket/features/survey/presentation/bloc/create_survey_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/create_survey_bloc.dart';

class CreateSurveyPage extends StatelessWidget {
  const CreateSurveyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Anket Oluştur')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<CreateSurveyBloc, CreateSurveyState>(
          listener: (context, state) {
            if (state.status == CreateSurveyStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Anket kaydedildi!')),
              );
              Navigator.pop(context);
            } else if (state.status == CreateSurveyStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kaydederken hata oluştu.')),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Soru'),
                  onChanged: (q) => context.read<CreateSurveyBloc>().add(QuestionChanged(q)),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.options.length,
                    itemBuilder: (ctx, index) {
                      return Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(labelText: 'Seçenek ${index + 1}'),
                              onChanged: (opt) => context.read<CreateSurveyBloc>().add(OptionChanged(index, opt)),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle),
                            onPressed: () => context.read<CreateSurveyBloc>().add(RemoveOption(index)),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => context.read<CreateSurveyBloc>().add(AddOption()),
                      icon: const Icon(Icons.add),
                      label: const Text('Seçenek Ekle'),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: state.isValid && state.status != CreateSurveyStatus.submitting
                          ? () => context.read<CreateSurveyBloc>().add(SubmitSurvey())
                          : null,
                      child: state.status == CreateSurveyStatus.submitting
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Kaydet'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}