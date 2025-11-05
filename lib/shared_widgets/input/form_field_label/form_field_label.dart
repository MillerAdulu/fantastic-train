import 'package:demo25/shared_widgets/input/form_field_label/_handset.dart';
import 'package:demo25/shared_widgets/input/form_field_label/_tablet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class FormFieldLabel extends StatelessWidget {
  const FormFieldLabel({
    required this.label,
    super.key,
    this.isRequired,
    this.color,
    this.isBold,
  });

  final String label;
  final bool? isRequired;
  final Color? color;
  final bool? isBold;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => FormFieldLabelTablet(
        label: label,
        isRequired: isRequired,
        color: color,
        isBold: isBold,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => FormFieldLabelHandset(
          label: label,
          isRequired: isRequired,
          color: color,
          isBold: isBold,
        ),
        tablet: (_, _) => FormFieldLabelTablet(
          label: label,
          isRequired: isRequired,
          color: color,
          isBold: isBold,
        ),
      ),
    );
  }
}
