import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FCNumberInputTablet extends StatelessWidget {
  const FCNumberInputTablet({
    required this.hintText,
    required this.controller,
    super.key,
    this.isLoading = false,
    this.prefixText,
  });

  final String hintText;
  final TextEditingController controller;
  final bool isLoading;
  final String? prefixText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        hintText: hintText,
        prefixText: prefixText,
        hintStyle: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
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
      style: theme.textTheme.titleMedium,
      controller: controller,
      enabled: !isLoading,
    );
  }
}
