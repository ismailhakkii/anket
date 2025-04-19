import 'package:equatable/equatable.dart';

class Survey extends Equatable {
  final String id;
  final String question;
  final List<String> options;

  const Survey({required this.id, required this.question, required this.options});

  @override
  List<Object?> get props => [id, question, options];
}
