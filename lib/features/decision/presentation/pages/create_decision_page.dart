import 'package:anket/features/decision/presentation/bloc/create_decision_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../bloc/create_decision_bloc.dart';

class CreateDecisionPage extends StatelessWidget {
  const CreateDecisionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Çark Oluştur')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<CreateDecisionBloc, CreateDecisionState>(
          listener: (context, state) {
            if (state.status == CreateDecisionStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Çark kaydedildi!')),
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
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.options.length,
                    itemBuilder: (ctx, index) {
                      final textController = TextEditingController(text: state.options[index]);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: textController,
                                decoration: InputDecoration(labelText: 'Seçenek ${index + 1}'),
                                onChanged: (val) => context.read<CreateDecisionBloc>().add(OptionTextChanged(index, val)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () async {
                                final color = await showDialog<Color>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Renk Seçin'),
                                    content: SingleChildScrollView(
                                      child: ColorPicker(
                                        pickerColor: state.colors[index],
                                        onColorChanged: (col) {},
                                        showLabel: true,
                                        pickerAreaHeightPercent: 0.7,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text('İptal'),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      TextButton(
                                        child: const Text('Seç'),
                                        onPressed: () => Navigator.pop(context, state.colors[index]),
                                      ),
                                    ],
                                  ),
                                );
                                if (color != null) {
                                  context.read<CreateDecisionBloc>().add(OptionColorChanged(index, color));
                                }
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: state.colors[index],
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle),
                              onPressed: state.options.length > 1
                                  ? () => context.read<CreateDecisionBloc>().add(RemoveOption(index))
                                  : null,
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
                      icon: const Icon(Icons.add),
                      label: const Text('Seçenek Ekle'),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: state.isValid && state.status != CreateDecisionStatus.submitting
                          ? () => context.read<CreateDecisionBloc>().add(SubmitOptions())
                          : null,
                      child: state.status == CreateDecisionStatus.submitting
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