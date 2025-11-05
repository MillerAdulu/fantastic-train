import 'package:demo25/shared_widgets/input/name/_handset.dart';
import 'package:demo25/shared_widgets/input/name/_tablet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class FCNameInput extends StatelessWidget {
  const FCNameInput({
    required this.hintText,
    required this.controller,
    super.key,
    this.enabled = true,
  });

  final String hintText;
  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => FCNameInputTablet(
        hintText: hintText,
        enabled: enabled,
        controller: controller,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => FCNameInputHandset(
          hintText: hintText,
          enabled: enabled,
          controller: controller,
        ),
        tablet: (_, _) => FCNameInputTablet(
          hintText: hintText,
          enabled: enabled,
          controller: controller,
        ),
      ),
    );
  }
}
