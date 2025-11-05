import 'package:demo25/shared_widgets/input/text/_handset.dart';
import 'package:demo25/shared_widgets/input/text/_tablet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class FCTextInput extends StatelessWidget {
  const FCTextInput({
    required this.hintText,
    required this.controller,
    super.key,
    this.enabled = true,
    this.onChanged,
  });

  final String hintText;
  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => FCTextInputTablet(
        hintText: hintText,
        controller: controller,
        enabled: enabled,
        onChanged: onChanged,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => FCTextInputHandset(
          hintText: hintText,
          controller: controller,
          enabled: enabled,
          onChanged: onChanged,
        ),
        tablet: (_, _) => FCTextInputTablet(
          hintText: hintText,
          controller: controller,
          enabled: enabled,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
