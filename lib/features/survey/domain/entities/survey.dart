import 'package:equatable/equatable.dart';

class Survey extends Equatable {
  final String id;
  final String question;
  final List<String> options;

  const Survey({required this.id, required this.question, required this.options});

  @override
  List<Object?> get props => [id, question, options];

  Map<String, dynamic> toJson() => {
    'id': id,
    'question': question,
    'options': options,
  };

  factory Survey.fromJson(Map<String, dynamic> json) => Survey(
    id: json['id'] as String,
    question: json['question'] as String,
    options: List<String>.from(json['options'] as List),
  );
}
