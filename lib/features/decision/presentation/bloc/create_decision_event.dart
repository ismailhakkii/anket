import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CreateDecisionEvent extends Equatable {
  const CreateDecisionEvent();

  @override
  List<Object?> get props => [];
}

class OptionTextChanged extends CreateDecisionEvent {
  final int index;
  final String text;
  const OptionTextChanged(this.index, this.text);

  @override
  List<Object?> get props => [index, text];
}

class OptionColorChanged extends CreateDecisionEvent {
  final int index;
  final Color color;
  const OptionColorChanged(this.index, this.color);

  @override
  List<Object?> get props => [index, color];
}

class AddOption extends CreateDecisionEvent {}

class RemoveOption extends CreateDecisionEvent {
  final int index;
  const RemoveOption(this.index);

  @override
  List<Object?> get props => [index];
}

class SubmitOptions extends CreateDecisionEvent {}