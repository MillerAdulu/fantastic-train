import 'package:demo25/shared_widgets/progress/circular_progress_indicator.dart';
import 'package:flutter/material.dart';

class FCDestroyButtonHandset extends StatelessWidget {
  const FCDestroyButtonHandset({
    required this.onPressed,
    required this.title,
    required this.disabled,
    super.key,
    this.isLoading,
  });

  final VoidCallback onPressed;
  final String title;
  final bool disabled;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (disabled || (isLoading ?? false)) ? null : onPressed,
        style: theme.elevatedButtonTheme.style?.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return theme.colorScheme.error.withValues(alpha: 0.4);
            }
            return theme.colorScheme.error;
          }),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading ?? false) ...[
              const SizedBox(
                height: 16,
                width: 16,
                child: FCCircularProgressIndicator(color: Colors.white),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onError,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
