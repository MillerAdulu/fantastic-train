import 'package:demo25/shared_widgets/input/email_address/_handset.dart';
import 'package:demo25/shared_widgets/input/email_address/_tablet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class FCEmailInput extends StatelessWidget {
  const FCEmailInput({
    required this.hintText,
    required this.emailController,
    super.key,
    this.enabled = true,
  });

  final String hintText;
  final TextEditingController emailController;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => FCEmailInputTablet(
        hintText: hintText,
        emailController: emailController,
        enabled: enabled,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => FCEmailInputHandset(
          hintText: hintText,
          emailController: emailController,
          enabled: enabled,
        ),
        tablet: (_, _) => FCEmailInputTablet(
          hintText: hintText,
          emailController: emailController,
          enabled: enabled,
        ),
      ),
    );
  }
}
