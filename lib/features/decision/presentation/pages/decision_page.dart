import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:confetti/confetti.dart';
import '../bloc/decision_bloc.dart';

class DecisionPage extends StatefulWidget {
  const DecisionPage({Key? key}) : super(key: key);

  @override
  State<DecisionPage> createState() => _DecisionPageState();
}

class _DecisionPageState extends State<DecisionPage> {
  final StreamController<int> _selected = StreamController<int>();
  List<String> _options = [];
  bool _spinning = false;
  String? _resultText;  // store result to show after animation
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
    context.read<DecisionBloc>().add(LoadOptions());
  }

  @override
  void dispose() {
    _selected.close();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Karar Verme Çarkı')),
      body: Center(
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
              return const CircularProgressIndicator();
            }
            if (_options.isEmpty) {
              return const Text('Hiç seçenek yok');
            }
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 300,
                      child: FortuneWheel(
                        selected: _selected.stream,
                        onAnimationEnd: () {
                          if (_resultText != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Sonuç: $_resultText')),
                            );
                            _confettiController.play();
                          }
                        },
                        items: [ for (var opt in _options) FortuneItem(child: Text(opt)) ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _spinning ? null : () => context.read<DecisionBloc>().add(SpinDecisionEvent()),
                      icon: const Icon(Icons.casino),
                      label: _spinning ? const Text('Dönüyor...') : const Text('Çarkı Döndür'),
                    ),
                  ],
                ),
                // Confetti
                ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [Colors.pink, Colors.purple, Colors.deepPurple],
                  emissionFrequency: 0.6,
                  numberOfParticles: 20,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}