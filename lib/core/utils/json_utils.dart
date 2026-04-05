import 'dart:convert';

List<String> decodeStringList(String? json) {
  if (json == null || json.isEmpty) return [];
  try {
    return List<String>.from(jsonDecode(json) as List);
  } catch (_) {
    return [];
  }
}

String encodeStringList(List<String> list) => jsonEncode(list);

Map<String, dynamic> decodeMap(String? json) {
  if (json == null || json.isEmpty) return {};
  try {
    return Map<String, dynamic>.from(jsonDecode(json) as Map);
  } catch (_) {
    return {};
  }
}
