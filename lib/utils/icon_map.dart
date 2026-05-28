import 'package:flutter/material.dart';

// Map habit icon keys to const IconData values so IconData is only created
// at compile-time and the Flutter tree-shaker can remove unused glyphs.
const Map<String, IconData> kIconMap = {
  'import_contacts': Icons.import_contacts,
  'favorite': Icons.favorite,
  'psychology': Icons.psychology,
  'edit_note': Icons.edit_note,
  'help_outline': Icons.help_outline,
};
