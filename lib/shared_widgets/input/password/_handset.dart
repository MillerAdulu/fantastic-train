import 'package:flutter/material.dart';

class FCPasswordInputHandset extends StatelessWidget {
  const FCPasswordInputHandset({
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
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            onPressed: () {
              hidePasswordNotifier.value = !hidePassword;
            },
            icon: Icon(
              hidePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
          ),
        ),
      ),
    );
  }
}
