import 'package:flutter/material.dart';

class TaskArea {
  final String id;
  final String label;
  final String emoji;
  final Color color;

  const TaskArea({
    required this.id,
    required this.label,
    required this.emoji,
    required this.color,
  });
}

const kTaskAreas = [
  TaskArea(id: 'trabajo', label: 'Trabajo', emoji: '\u{1F4BC}', color: Color(0xFF5B7E9E)),
  TaskArea(id: 'estudio', label: 'Facultad', emoji: '\u{1F4DA}', color: Color(0xFF7B5EA7)),
  TaskArea(id: 'personal', label: 'Personal', emoji: '\u{1F3E0}', color: Color(0xFF5B8A5E)),
  TaskArea(id: 'casa', label: 'Casa', emoji: '\u{1F3E1}', color: Color(0xFFC4963A)),
  TaskArea(id: 'salud', label: 'Salud', emoji: '\u{1F3E5}', color: Color(0xFFC44B4B)),
];

TaskArea? getTaskArea(String? areaId) {
  if (areaId == null) return null;
  try {
    return kTaskAreas.firstWhere((a) => a.id == areaId);
  } catch (_) {
    return null;
  }
}
