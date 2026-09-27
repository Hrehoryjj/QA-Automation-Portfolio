import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const DeleteConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final cs    = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width * 0.82;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
                child: Column(children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF3B30).withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(CupertinoIcons.delete, color: Color(0xFFFF3B30), size: 24),
                  ),
                  const SizedBox(height: 16),
                  Text(title, textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: cs.onSurface)),
                  const SizedBox(height: 8),
                  Text(message, textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant, height: 1.4)),
                ]),
              ),

              const SizedBox(height: 20),

              Divider(height: 1, thickness: 0.5, color: cs.outlineVariant),

              IntrinsicHeight(
                child: Row(children: [
                  Expanded(
                    child: _DialogButton(
                      label: 'Cancel',
                      color: cs.onSurface,
                      fontWeight: FontWeight.w500,
                      isLeft: true,
                      onTap: onCancel,
                    ),
                  ),
                  VerticalDivider(width: 0.5, thickness: 0.5, color: cs.outlineVariant),
                  Expanded(
                    child: _DialogButton(
                      label: 'Delete',
                      color: const Color(0xFFFF3B30),
                      fontWeight: FontWeight.w600,
                      isLeft: false,
                      onTap: onConfirm,
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String label;
  final Color color;
  final FontWeight fontWeight;
  final bool isLeft;
  final VoidCallback onTap;

  const _DialogButton({
    required this.label, required this.color, required this.fontWeight,
    required this.isLeft, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.only(
        bottomLeft:  isLeft  ? const Radius.circular(22) : Radius.zero,
        bottomRight: !isLeft ? const Radius.circular(22) : Radius.zero,
      ),
      child: Container(
        height: 52,
        alignment: Alignment.center,
        child: Text(label, style: TextStyle(
          fontSize: 16, fontWeight: fontWeight, color: color,
        )),
      ),
    );
  }
}
