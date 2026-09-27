import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {
  final Function(String) onChanged;
  final TextEditingController controller;
  final double topPadding;

  const AppSearchBar({
    super.key,
    required this.onChanged,
    required this.controller,
    this.topPadding = 4,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, topPadding, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outline.withValues(alpha: 0.35), width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CupertinoSearchTextField(
          controller: controller,
          onChanged: onChanged,
          key: const Key('input_search_transactions'),
          placeholder: 'Search transactions',
          backgroundColor: Colors.transparent,
          style: TextStyle(color: cs.onSurface, fontSize: 15),
          placeholderStyle: TextStyle(color: cs.onSurfaceVariant, fontSize: 15),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          prefixIcon: Icon(CupertinoIcons.search, color: cs.onSurfaceVariant, size: 17),
          suffixIcon: const Icon(CupertinoIcons.xmark_circle_fill, size: 17),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
