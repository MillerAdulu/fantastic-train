import 'package:demo25/shared_widgets/navbar/_handset.dart';
import 'package:demo25/shared_widgets/navbar/_tablet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class FCNavBar extends StatelessWidget {
  const FCNavBar({
    required this.title,
    super.key,
    this.onBack,
    this.actions,
    this.backIcon,
    this.backgroundColor,
    this.centerTitle = true,
  });

  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final IconData? backIcon;
  final Color? backgroundColor;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => FCNavBarTablet(
        title: title,
        onBack: onBack,
        actions: actions,
        backIcon: backIcon,
        backgroundColor: backgroundColor,
        centerTitle: centerTitle,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => FCNavBarHandset(
          title: title,
          onBack: onBack,
          actions: actions,
          backIcon: backIcon,
          backgroundColor: backgroundColor,
          centerTitle: centerTitle,
        ),
        tablet: (_, _) => FCNavBarTablet(
          title: title,
          onBack: onBack,
          actions: actions,
          backIcon: backIcon,
          backgroundColor: backgroundColor,
          centerTitle: centerTitle,
        ),
      ),
    );
  }
}
