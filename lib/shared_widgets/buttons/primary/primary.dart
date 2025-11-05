import 'package:demo25/shared_widgets/buttons/primary/_handset.dart';
import 'package:demo25/shared_widgets/buttons/primary/_tablet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class FCPrimaryButton extends StatelessWidget {
  const FCPrimaryButton({
    required this.onPressed,
    required this.title,
    required this.disabled,
    super.key,
    this.isLoading,
  });

  final VoidCallback onPressed;
  final String title;
  final bool disabled;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => FCPrimaryButtonTablet(
        onPressed: onPressed,
        title: title,
        disabled: disabled,
        isLoading: isLoading,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => FCPrimaryButtonHandset(
          onPressed: onPressed,
          title: title,
          disabled: disabled,
          isLoading: isLoading,
        ),
        tablet: (_, _) => FCPrimaryButtonTablet(
          onPressed: onPressed,
          title: title,
          disabled: disabled,
          isLoading: isLoading,
        ),
      ),
    );
  }
}
