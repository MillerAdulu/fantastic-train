import 'package:flutter/material.dart';

class FCPasswordInputTablet extends StatelessWidget {
  const FCPasswordInputTablet({
    required this.hintText,
    required this.hidePasswordNotifier,
    required this.passwordController,
    super.key,
    this.enabled = true,
  });

  final String hintText;
  final ValueNotifier<bool> hidePasswordNotifier;
  final TextEditingController passwordController;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<bool>(
      valueListenable: hidePasswordNotifier,
      builder: (context, hidePassword, child) => TextFormField(
        controller: passwordController,
        enabled: enabled,
        obscureText: hidePassword,
        keyboardType: TextInputType.visiblePassword,
        style: theme.textTheme.titleMedium,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          prefixIcon: const Icon(Icons.lock_outline, size: 24),
          suffixIcon: IconButton(
            onPressed: () {
              hidePasswordNotifier.value = !hidePassword;
            },
            icon: Icon(
              hidePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 24,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
          ),
        ),
      ),
    );
  }
}
