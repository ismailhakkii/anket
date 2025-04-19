import 'package:anket/features/survey/presentation/bloc/create_survey_event.dart';
import 'package:anket/features/survey/presentation/bloc/create_survey_state.dart';
import 'package:anket/features/survey/presentation/bloc/survey_bloc.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/create_survey_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateSurveyPage extends StatefulWidget {
  const CreateSurveyPage({Key? key}) : super(key: key);

  @override
  State<CreateSurveyPage> createState() => _CreateSurveyPageState();
}

class _CreateSurveyPageState extends State<CreateSurveyPage> {
  bool _showAnimation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Yeni Anket Oluştur', style: GoogleFonts.poppins())),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: BlocConsumer<CreateSurveyBloc, CreateSurveyState>(
              listener: (context, state) async {
                if (state.status == CreateSurveyStatus.success) {
                  // update surveys list
                  context.read<SurveyBloc>().add(LoadSurveys());
                  // show success animation
                  setState(() {
                    _showAnimation = true;
                  });
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() {
                    _showAnimation = false;
                  });
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Seçenek ${index + 1}',
                                      labelStyle: GoogleFonts.poppins(),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                    ),
                                    onChanged: (opt) => context.read<CreateSurveyBloc>().add(OptionChanged(index, opt)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                                  onPressed: () => context.read<CreateSurveyBloc>().add(RemoveOption(index)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () => context.read<CreateSurveyBloc>().add(AddOption()),
                          icon: const Icon(Icons.add_circle_outline),
                          label: Text('Seçenek Ekle', style: GoogleFonts.poppins()),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: state.isValid && state.status != CreateSurveyStatus.submitting
                              ? () => context.read<CreateSurveyBloc>().add(SubmitSurvey())
                              : null,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: state.status == CreateSurveyStatus.submitting
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : Text('Kaydet', style: GoogleFonts.poppins(fontSize: 16)),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          if (_showAnimation)
            Lottie.asset('assets/animations/success.json', width: 200, height: 200),
        ],
      ),
    );
  }
}