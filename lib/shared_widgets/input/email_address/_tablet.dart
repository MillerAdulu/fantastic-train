import 'package:flutter/material.dart';

class FCEmailInputTablet extends StatelessWidget {
  const FCEmailInputTablet({
    required this.hintText,
    required this.emailController,
    super.key,
    this.enabled = true,
  });

  final String hintText;
  final TextEditingController emailController;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: emailController,
      enabled: enabled,
      keyboardType: TextInputType.emailAddress,
      style: theme.textTheme.titleMedium,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.email_outlined, size: 24),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
      ),
    );
  }
}
