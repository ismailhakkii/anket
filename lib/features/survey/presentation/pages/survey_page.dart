import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
      appBar: AppBar(
        title: Text('Anketler', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<SurveyBloc, SurveyState>(
            builder: (context, state) {
              if (state is SurveyLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is SurveyLoaded) {
                final surveys = state.surveys;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: surveys.length,
                  itemBuilder: (context, index) {
                    final survey = surveys[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 6,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(survey.question, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 12),
                            ...survey.options.map((opt) => ListTile(
                                  leading: Radio<String>(
                                    value: opt,
                                    groupValue: selectedOption,
                                    activeColor: Colors.purple,
                                    onChanged: (value) => setState(() => selectedOption = value),
                                  ),
                                  title: Text(opt, style: GoogleFonts.poppins()),
                                )),
                            const SizedBox(height: 8),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                ),
                                onPressed: selectedOption == null
                                    ? null
                                    : () => ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Seçiminiz: $selectedOption', style: GoogleFonts.poppins())),
                                      ),
                                child: Text('Gönder', style: GoogleFonts.poppins(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              if (state is SurveyError) {
                return Center(child: Text(state.message, style: GoogleFonts.poppins(color: Colors.white)));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}