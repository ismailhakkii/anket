import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:confetti/confetti.dart';
import '../bloc/decision_bloc.dart';

class DecisionPage extends StatefulWidget {
  const DecisionPage({super.key});

  @override
  State<DecisionPage> createState() => _DecisionPageState();
}

class _DecisionPageState extends State<DecisionPage> with SingleTickerProviderStateMixin {
  final StreamController<int> _selected = StreamController<int>();
  List<String> _options = [];
  bool _spinning = false;
  String? _resultText;
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    context.read<DecisionBloc>().add(LoadOptions());
  }

  @override
  void dispose() {
    _selected.close();
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _showResultDialog() {
    if (_resultText == null) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.deepPurple.shade50,
        title: const Text('Sonuç', 
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Text(
              _resultText!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_events,
                color: Colors.deepPurple,
                size: 80,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Tamam',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Karar Çarkı',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade800,
              Colors.deepPurple.shade500,
              Colors.purple.shade300,
            ],
          ),
        ),
        child: Center(
          child: BlocConsumer<DecisionBloc, DecisionState>(
            listener: (context, state) {
              if (state is DecisionOptionsLoaded) {
                setState(() { _options = state.options; });
              } else if (state is DecisionSpun) {
                _selected.add(state.result.selectedIndex);
                setState(() {
                  _spinning = false;
                  _resultText = state.result.options[state.result.selectedIndex];
                });
              } else if (state is DecisionSpinning) {
                setState(() { _spinning = true; });
              } else if (state is DecisionError) {
                setState(() { _spinning = false; });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              if (state is DecisionLoadingOptions) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                );
              }
              
              if (_options.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.sentiment_dissatisfied,
                        color: Colors.white70,
                        size: 80,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Henüz hiç seçenek yok',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Yeni Çark Oluştur',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Çarkın üzerindeki başlık
                        AnimatedOpacity(
                          opacity: _spinning ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: const Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text(
                              'Şansına Güven!',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        
                        // Ana çark
                        Container(
                          height: 340,
                          width: 340,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(170),
                            ),
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: FortuneWheel(
                                selected: _selected.stream,
                                animateFirst: false,
                                physics: CircularPanPhysics(
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.decelerate,
                                ),
                                styleStrategy: UniformStyleStrategy(
                                  borderColor: Colors.white,
                                  borderWidth: 3,
                                ),
                                onAnimationEnd: () {
                                  if (_resultText != null) {
                                    _confettiController.play();
                                    Future.delayed(
                                      const Duration(milliseconds: 500), 
                                      _showResultDialog
                                    );
                                  }
                                },
                                indicators: const [
                                  FortuneIndicator(
                                    alignment: Alignment.topCenter,
                                    child: TriangleIndicator(
                                      color: Colors.white,
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                ],
                                items: List.generate(_options.length, (i) {
                                  // Çarkta metinleri düzgün gösterme için rotation
                                  return FortuneItem(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20, 
                                        right: 20, 
                                        top: 35
                                      ),
                                      child: RotatedBox(
                                        quarterTurns: 1,
                                        child: Text(
                                          _options[i],
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    style: FortuneItemStyle(
                                      color: Colors.primaries[i % Colors.primaries.length].shade600,
                                      borderColor: Colors.white,
                                      borderWidth: 2,
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Döndürme butonu
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _spinning ? 0.95 : 1.0 + (_animation.value * 0.05),
                              child: child,
                            );
                          },
                          child: GestureDetector(
                            onTapDown: (_) {
                              if (!_spinning) _animationController.forward();
                            },
                            onTapUp: (_) {
                              if (!_spinning) {
                                _animationController.reverse();
                                context.read<DecisionBloc>().add(SpinDecisionEvent());
                              }
                            },
                            onTapCancel: () {
                              if (!_spinning) _animationController.reverse();
                            },
                            child: Container(
                              width: 200,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.pink.shade400,
                                    Colors.deepPurple.shade400,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurple.shade700.withOpacity(0.5),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _spinning ? Icons.hourglass_top : Icons.casino,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      _spinning ? 'Dönüyor...' : 'Çarkı Döndür',
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Konfeti efekti
                  Align(
                    alignment: Alignment.center,
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirectionality: BlastDirectionality.explosive,
                      shouldLoop: false,
                      colors: const [
                        Colors.pink, 
                        Colors.purple, 
                        Colors.deepPurple,
                        Colors.yellow,
                        Colors.cyan,
                        Colors.orange,
                      ],
                      minimumSize: const Size(10, 10),
                      maximumSize: const Size(20, 20),
                      emissionFrequency: 0.8,
                      numberOfParticles: 30,
                      gravity: 0.2,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}