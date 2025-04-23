import 'package:anket/features/decision/presentation/bloc/create_decision_event.dart';
import 'package:anket/features/decision/presentation/bloc/create_decision_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:lottie/lottie.dart';
import '../bloc/create_decision_bloc.dart';

class CreateDecisionPage extends StatefulWidget {
  const CreateDecisionPage({super.key});

  @override
  State<CreateDecisionPage> createState() => _CreateDecisionPageState();
}

class _CreateDecisionPageState extends State<CreateDecisionPage> with SingleTickerProviderStateMixin {
  bool _showSuccess = false;
  late AnimationController _animationController;
  late Animation<Offset> _addButtonAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    
    _addButtonAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuad,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _showColorPicker(BuildContext context, Color initialColor, Function(Color) onColorChanged) async {
    Color pickerColor = initialColor;
    
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Renk Seçin',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Renk önizleme
                Container(
                  width: double.infinity,
                  height: 60,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: pickerColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                
                // Renk seçici
                ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: (Color color) {
                    pickerColor = color;
                  },
                  labelTypes: const [],
                  pickerAreaHeightPercent: 0.8,
                  enableAlpha: false,
                  displayThumbColor: true,
                  portraitOnly: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'İptal',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.grey,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () {
                onColorChanged(pickerColor);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Seç',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Yeni Çark Oluştur',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Arkaplan 
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade700, 
                  Colors.deepPurple.shade400,
                  Colors.purple.shade300,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          // Ana içerik
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: BlocConsumer<CreateDecisionBloc, CreateDecisionState>(
                listener: (context, state) async {
                  if (state.status == CreateDecisionStatus.success) {
                    setState(() { _showSuccess = true; });
                    await Future.delayed(const Duration(seconds: 2));
                    if (mounted) {
                      setState(() { _showSuccess = false; });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Çark başarıyla kaydedildi!',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  } else if (state.status == CreateDecisionStatus.failure) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Çark kaydedilirken bir hata oluştu.',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Başlık
                      const Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 16),
                        child: Text(
                          'Karar Çarkınızı Özelleştirin',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      
                      // Önizleme (Seçenek sayısını ve renklerini gösterir)
                      Container(
                        height: 80,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.preview, color: Colors.white70),
                              const SizedBox(width: 8),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                  children: [
                                    const TextSpan(text: 'Çarkınızda '),
                                    TextSpan(
                                      text: '${state.options.length}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const TextSpan(text: ' seçenek var'),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Text(
                                '|',
                                style: TextStyle(color: Colors.white54, fontSize: 20),
                              ),
                              const SizedBox(width: 16),
                              Wrap(
                                spacing: 5,
                                children: List.generate(
                                  min(5, state.colors.length), 
                                  (index) => Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: state.colors[index],
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 1),
                                    ),
                                  ),
                                ),
                              ),
                              if (state.colors.length > 5)
                                Container(
                                  width: 20, 
                                  height: 20,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 1),
                                  ),
                                  child: Text(
                                    '+${state.colors.length - 5}',
                                    style: const TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Seçenek listesi
                      Expanded(
                        child: AnimatedList(
                          initialItemCount: state.options.length,
                          itemBuilder: (context, index, animation) {
                            return _buildOptionItem(context, index, state, animation);
                          },
                        ),
                      ),
                      
                      // Alt butonlar
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: [
                            // Seçenek ekle butonu
                            SlideTransition(
                              position: _addButtonAnimation,
                              child: ElevatedButton.icon(
                                onPressed: () => context.read<CreateDecisionBloc>().add(AddOption()),
                                icon: const Icon(Icons.add_circle_outline),
                                label: const Text(
                                  'Seçenek Ekle',
                                  style: TextStyle(fontFamily: 'Poppins'),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple.shade300,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            
                            // Kaydet butonu
                            ElevatedButton(
                              onPressed: state.isValid && state.status != CreateDecisionStatus.submitting
                                  ? () => context.read<CreateDecisionBloc>().add(SubmitOptions())
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pinkAccent,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 5,
                                shadowColor: Colors.pinkAccent.withOpacity(0.5),
                              ),
                              child: state.status == CreateDecisionStatus.submitting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.save_alt),
                                        SizedBox(width: 8),
                                        Text(
                                          'Kaydet',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          
          // Başarı animasyonu
          if (_showSuccess)
            Lottie.asset('assets/animations/success.json', width: 200, height: 200),
        ],
      ),
    );
  }
  
  Widget _buildOptionItem(BuildContext context, int index, CreateDecisionState state, Animation<double> animation) {
    final textCtrl = TextEditingController(text: state.options[index]);
    
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutQuad,
      )),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
          child: Row(
            children: [
              // Seçenek numarası ve renk belirteci
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: state.colors[index],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Metin giriş alanı
              Expanded(
                child: TextField(
                  controller: textCtrl,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Seçenek ${index + 1}',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (val) => context.read<CreateDecisionBloc>().add(OptionTextChanged(index, val)),
                ),
              ),
              
              // Renk seçici butonu
              IconButton(
                icon: const Icon(Icons.color_lens, color: Colors.white70),
                onPressed: () {
                  _showColorPicker(
                    context,
                    state.colors[index],
                    (color) => context.read<CreateDecisionBloc>().add(OptionColorChanged(index, color)),
                  );
                },
              ),
              
              // Seçeneği silme butonu
              IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                onPressed: state.options.length > 2
                    ? () => context.read<CreateDecisionBloc>().add(RemoveOption(index))
                    : null,
                tooltip: state.options.length > 2 ? 'Seçeneği Sil' : 'En az 2 seçenek gerekli',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Yardımcı fonksiyon
int min(int a, int b) {
  return a < b ? a : b;
}