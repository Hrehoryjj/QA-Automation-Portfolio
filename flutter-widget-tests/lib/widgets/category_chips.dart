import 'package:flutter/material.dart';
import '../models/category.dart';
import '../utils/emoji_color.dart';
import '../main.dart' show AppColors;

class CategoryChips extends StatelessWidget {
  final List<TransactionCategory> categories;
  final String? selectedId;
  final ValueChanged<String?> onSelected;
  final bool scrollable;

  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onSelected,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final chips = categories.map((cat) {
      return _CategoryChip(
        key: ValueKey(cat.id),
        cat: cat,
        isSelected: cat.id == selectedId,
        onTap: () => onSelected(selectedId == cat.id ? null : cat.id),
      );
    }).toList();

    if (scrollable) {
      return SizedBox(
        height: 46,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          itemCount: chips.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) => chips[i],
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips,
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final TransactionCategory cat;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    super.key,
    required this.cat,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradStart = isDark ? AppColors.cardDarkStart : AppColors.cardLightStart;
    final gradEnd   = isDark ? AppColors.cardDarkEnd   : AppColors.cardLightEnd;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.fromLTRB(5, 6, 12, 6),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [gradStart, gradEnd],
                  begin: Alignment.topLeft, end: Alignment.bottomRight)
              : null,
          color: isSelected ? null : cs.surface,
          borderRadius: BorderRadius.circular(23),
          border: isSelected ? null : Border.all(color: cs.outlineVariant),
          boxShadow: isSelected
              ? [BoxShadow(color: gradStart.withValues(alpha: 0.3),
                  blurRadius: 6, offset: const Offset(0, 2))]
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 3, offset: const Offset(0, 1))],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: EmojiColor.backgroundFor(cat.emoji, dark: false),
              shape: BoxShape.circle,
            ),
            child: Center(child: Text(cat.emoji,
              style: const TextStyle(fontSize: 15))),
          ),
          const SizedBox(width: 7),
          Text(cat.name, style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : cs.onSurface,
          )),
        ]),
      ),
    );
  }
}
