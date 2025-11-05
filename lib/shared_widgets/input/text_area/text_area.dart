import 'package:demo25/shared_widgets/input/text_area/_handset.dart';
import 'package:demo25/shared_widgets/input/text_area/_tablet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class FCTextAreaInput extends StatelessWidget {
  const FCTextAreaInput({
    required this.hintText,
    required this.controller,
    super.key,
    this.enabled = true,
    this.maxLines = 5,
    this.minLines = 3,
  });

  final String hintText;
  final TextEditingController controller;
  final bool enabled;
  final int minLines;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => FCTextAreaInputTablet(
        hintText: hintText,
        controller: controller,
        maxLines: maxLines,
        minLines: minLines,
        enabled: enabled,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => FCTextAreaInputHandset(
          hintText: hintText,
          controller: controller,
          maxLines: maxLines,
          minLines: minLines,
          enabled: enabled,
        ),
        tablet: (_, _) => FCTextAreaInputTablet(
          hintText: hintText,
          controller: controller,
          maxLines: maxLines,
          minLines: minLines,
          enabled: enabled,
        ),
      ),
    );
  }
}
