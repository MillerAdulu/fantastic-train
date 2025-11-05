import 'package:demo25/shared_widgets/input/password/_handset.dart';
import 'package:demo25/shared_widgets/input/password/_tablet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class FCPasswordInput extends StatelessWidget {
  const FCPasswordInput({
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
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => FCPasswordInputTablet(
        hintText: hintText,
        hidePasswordNotifier: hidePasswordNotifier,
        passwordController: passwordController,
        enabled: enabled,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => FCPasswordInputHandset(
          hintText: hintText,
          hidePasswordNotifier: hidePasswordNotifier,
          passwordController: passwordController,
          enabled: enabled,
        ),
        tablet: (_, _) => FCPasswordInputTablet(
          hintText: hintText,
          hidePasswordNotifier: hidePasswordNotifier,
          passwordController: passwordController,
          enabled: enabled,
        ),
      ),
    );
  }
}
