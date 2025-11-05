import 'package:auto_route/auto_route.dart';
import 'package:demo25/utils/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gaimon/gaimon.dart';

class GenerateAccountSuccessView extends StatelessWidget {
  const GenerateAccountSuccessView({required this.email, super.key});
  final String email;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Account Created!',
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Icon(
            Icons.celebration_rounded,
            size: 64,
            color: Colors.amber,
          ),
          const SizedBox(height: 24),
          Text(
            'Here is your unique sign-in code.',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Please save it in a safe place. You will need it to sign in '
            'next time.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                email.replaceAll('@fluttercondev.ke', ''),
                style: theme.textTheme.displayMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  letterSpacing: 8,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Gaimon.selection();
              Clipboard.setData(
                ClipboardData(
                  text: email.replaceAll('@fluttercondev.ke', ''),
                ),
              );
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Code copied to clipboard!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
            },
            icon: const Icon(Icons.copy_all_rounded, size: 20),
            label: const Text('Copy Code'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              Gaimon.selection();
              Navigator.of(context).pop();
              context.router.pushPath(FCRouter.landing);
            },
            child: const Text('Continue to App'),
          ),
        ],
      ).animate().fadeIn(duration: 300.ms),
    );
  }
}
