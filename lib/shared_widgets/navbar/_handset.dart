import 'package:demo25/utils/router/router.dart';
import 'package:flutter/material.dart';

class FCNavBarHandset extends StatelessWidget {
  const FCNavBarHandset({
    required this.title,
    required this.centerTitle,
    super.key,
    this.onBack,
    this.actions,
    this.backIcon,
    this.backgroundColor,
  });

  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final IconData? backIcon;
  final Color? backgroundColor;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      pinned: true,
      elevation: 0,
      toolbarHeight: 80,
      flexibleSpace: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.colorScheme.surface,
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: .2),
            ),
          ),
        ),
        child: Row(
          children: [
            // Back Button
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  backIcon ?? Icons.arrow_back_ios_new,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 20,
                ),
                onPressed:
                    onBack ??
                    () => Navigator.of(context).popUntil(
                      ModalRoute.withName(FCRouter.landing),
                    ),
              ),
            ),
            // Title
            Expanded(
              child: Align(
                alignment: centerTitle
                    ? Alignment.center
                    : Alignment.centerLeft,
                child: Text(
                  title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: centerTitle ? TextAlign.center : TextAlign.left,
                ),
              ),
            ),
            // Actions or Spacer
            if (actions != null && actions!.isNotEmpty)
              Row(children: actions!)
            else
              const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}
