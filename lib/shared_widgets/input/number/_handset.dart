import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FCNumberInputHandset extends StatelessWidget {
  const FCNumberInputHandset({
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
      decoration: InputDecoration(hintText: hintText, prefixText: prefixText),
      style: theme.textTheme.bodyMedium,
      controller: controller,
      enabled: !isLoading,
    );
  }
}
