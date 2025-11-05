import 'package:demo25/shared_widgets/buttons/destroy/_handset.dart';
import 'package:demo25/shared_widgets/buttons/destroy/_tablet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class FCDestroyButton extends StatelessWidget {
  const FCDestroyButton({
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
      defaultBuilder: (_, _) => FCDestroyButtonTablet(
        onPressed: onPressed,
        title: title,
        disabled: disabled,
        isLoading: isLoading,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => FCDestroyButtonHandset(
          onPressed: onPressed,
          title: title,
          disabled: disabled,
          isLoading: isLoading,
        ),
        tablet: (_, _) => FCDestroyButtonTablet(
          onPressed: onPressed,
          title: title,
          disabled: disabled,
          isLoading: isLoading,
        ),
      ),
    );
  }
}
