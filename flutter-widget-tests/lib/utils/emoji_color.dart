import 'package:flutter/material.dart';

class EmojiColor {
  EmojiColor._();

  static const List<Color> _palette = [
    Color(0xFFFFE5E5),
    Color(0xFFFFEDD5),
    Color(0xFFFFF9C4),
    Color(0xFFE8F5E9),
    Color(0xFFE0F7FA),
    Color(0xFFE3F2FD),
    Color(0xFFEDE7F6),
    Color(0xFFFCE4EC),
    Color(0xFFF3E5F5),
    Color(0xFFE8EAF6),
    Color(0xFFFFF3E0),
    Color(0xFFE0F2F1),
  ];

  static const List<Color> _paletteDark = [
    Color(0xFF4A1515),
    Color(0xFF4A2800),
    Color(0xFF3D3400),
    Color(0xFF0D3318),
    Color(0xFF003740),
    Color(0xFF0A2540),
    Color(0xFF1E1040),
    Color(0xFF40101E),
    Color(0xFF2A0D40),
    Color(0xFF101530),
    Color(0xFF402600),
    Color(0xFF003830),
  ];

  static Color backgroundFor(String emoji, {bool dark = false}) {
    if (emoji.isEmpty) return dark ? const Color(0xFF2C2C2E) : const Color(0xFFE8E9F0);
    final palette = dark ? _paletteDark : _palette;
    final hash = _hashEmoji(emoji);
    return palette[hash % palette.length];
  }

  static int _hashEmoji(String emoji) {
    var h = 0;
    for (final rune in emoji.runes) {
      h = (h * 31 + rune) & 0x7FFFFFFF;
    }
    return h.abs();
  }
}
