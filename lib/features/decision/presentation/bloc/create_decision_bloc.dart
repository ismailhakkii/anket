import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../domain/usecases/save_decision_options.dart';
import 'create_decision_event.dart';
import 'create_decision_state.dart';

class CreateDecisionBloc extends Bloc<CreateDecisionEvent, CreateDecisionState> {
  final SaveDecisionOptions saveOptions;

  CreateDecisionBloc(this.saveOptions) : super(CreateDecisionState.initial()) {
    on<OptionTextChanged>((event, emit) {
      final opts = List<String>.from(state.options);
      opts[event.index] = event.text;
      emit(state.copyWith(options: opts));
    });

    on<AddOption>((event, emit) {
      final opts = List<String>.from(state.options)..add('');
      final colors = List<Color>.from(state.colors)
        ..add(Colors.primaries[state.colors.length % Colors.primaries.length]);
      emit(state.copyWith(options: opts, colors: colors));
    });

    on<RemoveOption>((event, emit) {
      final opts = List<String>.from(state.options)..removeAt(event.index);
      final colors = List<Color>.from(state.colors)..removeAt(event.index);
      emit(state.copyWith(options: opts, colors: colors));
    });

    on<OptionColorChanged>((event, emit) {
      final colors = List<Color>.from(state.colors);
      colors[event.index] = event.color;
      emit(state.copyWith(colors: colors));
    });

    on<SubmitOptions>((event, emit) async {
      if (!state.isValid) return;
      emit(state.copyWith(status: CreateDecisionStatus.submitting));
      try {
        await saveOptions.call(state.options);
        emit(state.copyWith(status: CreateDecisionStatus.success));
      } catch (_) {
        emit(state.copyWith(status: CreateDecisionStatus.failure));
      }
    });
  }
}