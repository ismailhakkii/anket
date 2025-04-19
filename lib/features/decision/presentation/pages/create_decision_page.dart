import 'package:anket/features/decision/presentation/bloc/create_decision_event.dart';
import 'package:anket/features/decision/presentation/bloc/create_decision_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../bloc/create_decision_bloc.dart';

class CreateDecisionPage extends StatefulWidget {
  const CreateDecisionPage({Key? key}) : super(key: key);

  @override
  State<CreateDecisionPage> createState() => _CreateDecisionPageState();
}

class _CreateDecisionPageState extends State<CreateDecisionPage> {
  bool _showSuccess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yeni Çark Oluştur', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: BlocConsumer<CreateDecisionBloc, CreateDecisionState>(
                  listener: (context, state) async {
                    if (state.status == CreateDecisionStatus.success) {
                      setState(() { _showSuccess = true; });
                      await Future.delayed(const Duration(seconds: 2));
                      setState(() { _showSuccess = false; });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Çark kaydedildi!', style: GoogleFonts.poppins())),
                      );
                      Navigator.pop(context);
                    } else if (state.status == CreateDecisionStatus.failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kaydederken hata oluştu.')),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.options.length,
                            itemBuilder: (ctx, index) {
                              final textCtrl = TextEditingController(text: state.options[index]);
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: textCtrl,
                                        style: GoogleFonts.poppins(),
                                        decoration: InputDecoration(
                                          labelText: 'Seçenek ${index + 1}',
                                          labelStyle: GoogleFonts.poppins(color: Colors.white70),
                                          filled: true,
                                          fillColor: Colors.white.withOpacity(0.2),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                        ),
                                        onChanged: (val) => context.read<CreateDecisionBloc>().add(OptionTextChanged(index, val)),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () async {
                                        final color = await showDialog<Color>(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: Text('Renk Seçin', style: GoogleFonts.poppins()),
                                            content: SingleChildScrollView(
                                              child: ColorPicker(
                                                pickerColor: state.colors[index],
                                                onColorChanged: (c) {},
                                                showLabel: false,
                                              ),
                                            ),
                                            actions: [
                                              TextButton(child: Text('İptal', style: GoogleFonts.poppins()), onPressed: () => Navigator.pop(context)),
                                              TextButton(child: Text('Seç', style: GoogleFonts.poppins()), onPressed: () => Navigator.pop(context, state.colors[index])),
                                            ],
                                          ),
                                        );
                                        if (color != null) context.read<CreateDecisionBloc>().add(OptionColorChanged(index, color));
                                      },
                                      child: Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: state.colors[index],
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                                      onPressed: state.options.length > 1 ? () => context.read<CreateDecisionBloc>().add(RemoveOption(index)) : null,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () => context.read<CreateDecisionBloc>().add(AddOption()),
                              icon: const Icon(Icons.add_circle, color: Colors.white),
                              label: Text('Seçenek Ekle', style: GoogleFonts.poppins(color: Colors.white)),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: state.isValid && state.status != CreateDecisionStatus.submitting
                                  ? () => context.read<CreateDecisionBloc>().add(SubmitOptions())
                                  : null,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14), backgroundColor: Colors.pinkAccent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              ),
                              child: state.status == CreateDecisionStatus.submitting
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : Text('Kaydet', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16)),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          if (_showSuccess)
            Lottie.asset('assets/animations/success.json', width: 180, height: 180),
        ],
      ),
    );
  }
}