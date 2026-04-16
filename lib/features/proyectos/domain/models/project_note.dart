class ProjectNote {
  final String id;
  final String text;
  final DateTime createdAt;

  const ProjectNote({
    required this.id,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'createdAt': createdAt.toIso8601String(),
  };

  factory ProjectNote.fromJson(Map<String, dynamic> json) => ProjectNote(
    id: json['id'] as String,
    text: json['text'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}
