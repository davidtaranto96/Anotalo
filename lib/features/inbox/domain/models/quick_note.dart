import 'package:equatable/equatable.dart';

enum QuickNoteType { idea, nota, tarea, proyecto, general }

class QuickNote extends Equatable {
  final String id;
  final String content;
  final QuickNoteType type;
  final bool isProcessed;
  final String? processedToType;
  final String? processedToTargetId;
  final List<String> tags;
  final DateTime createdAt;

  const QuickNote({
    required this.id,
    required this.content,
    required this.type,
    this.isProcessed = false,
    this.processedToType,
    this.processedToTargetId,
    this.tags = const [],
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, content, isProcessed];
}
