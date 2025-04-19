import 'dart:ui';

import 'package:anket/features/decision/domain/usecases/save_decision_options.dart';
import 'package:anket/features/decision/presentation/bloc/create_decision_event.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../domain/usecases/save_decision_options.dart';

part 'create_decision_event.dart';
part 'create_decision_state.dart';

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
      emit(state.copyWith(options: opts));
    });

    on<RemoveOption>((event, emit) {
      final opts = List<String>.from(state.options)..removeAt(event.index);
      emit(state.copyWith(options: opts));
    });

    on<SubmitOptions>((event, emit) async {
      if (!state.isValid) return;
      emit(state.copyWith(status: CreateDecisionStatus.submitting));
      try {
        await saveOptions(state.options);
        emit(state.copyWith(status: CreateDecisionStatus.success));
      } catch (_) {
        emit(state.copyWith(status: CreateDecisionStatus.failure));
      }
    });
  }
}