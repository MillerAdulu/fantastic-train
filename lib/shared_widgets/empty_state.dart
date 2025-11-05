import 'package:demo25/shared_widgets/buttons/primary/primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FCEmptyView extends StatelessWidget {
  const FCEmptyView({
    required this.label,
    required this.description,
    this.icon,
    this.action,
    this.actionLabel,
    this.onActionPressed,
    super.key,
  });

  final String label;
  final String description;
  final IconData? icon;
  final Widget? action;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon ?? Icons.inbox_outlined,
              size: 48,
              color: theme.colorScheme.primary,
            ),
          ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),
          const SizedBox(height: 16),
          Text(
            label,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0),
          const SizedBox(height: 8),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),
          if (action != null) ...[
            const SizedBox(height: 24),
            action!,
          ] else if (actionLabel != null && onActionPressed != null) ...[
            const SizedBox(height: 24),
            FCPrimaryButton(
              onPressed: () => onActionPressed?.call(),
              title: actionLabel!,
              disabled: onActionPressed == null,
            ).animate().fadeIn(delay: 500.ms).scale(delay: 100.ms),
          ],
        ],
      ),
    );
  }
}
