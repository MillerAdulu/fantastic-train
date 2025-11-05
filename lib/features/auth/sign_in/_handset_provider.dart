// lib/features/auth/sign_in/_handset_provider.dart

import 'package:demo25/features/auth/providers/auth_provider.dart';
import 'package:demo25/l10n/l10n.dart';
import 'package:demo25/services/api/auth_service.dart';
import 'package:demo25/utils/misc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gaimon/gaimon.dart';
import 'package:provider/provider.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class FCSignInHandsetProvider extends StatefulWidget {
  const FCSignInHandsetProvider({super.key});

  @override
  State<FCSignInHandsetProvider> createState() =>
      _FCSignInHandsetProviderState();
}

class _FCSignInHandsetProviderState extends State<FCSignInHandsetProvider>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final ValueNotifier<int> _pageIndexNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _pageIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.scaffoldBackgroundColor,
              theme.colorScheme.surface.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _AnimatedLogo(pulseController: _pulseController),
                  const SizedBox(height: 48),

                  // Welcome Text
                  Text(
                    l10n.welcome,
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.journeyStartsHere,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  _AuthOptionCard(
                    icon: Icons.qr_code_scanner_rounded,
                    title: l10n.iHaveACode,
                    description: l10n.iHaveACodeDesc,
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withValues(alpha: 0.7),
                      ],
                    ),
                    onTap: () {
                      Gaimon.selection();
                      _showCodeInputModal(context, l10n);
                    },
                  ),
                  const SizedBox(height: 16),
                  _AuthOptionCard(
                    icon: Icons.auto_awesome_rounded,
                    title: l10n.generateNewCode,
                    description: l10n.generateNewCodeDesc,
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.secondary,
                        theme.colorScheme.secondary.withValues(alpha: 0.7),
                      ],
                    ),
                    onTap: () {
                      Gaimon.selection();
                      _showGenerateAccountModal(context);
                    },
                  ),

                  const SizedBox(height: 64),
                  const _VersionBadge(),
                ],
              )
                  .animate(delay: 100.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(
                    begin: 0.2,
                    end: 0,
                    curve: Curves.easeOutCubic,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCodeInputModal(BuildContext context, AppLocalizations l10n) =>
      WoltModalSheet.show<void>(
        context: context,
        pageIndexNotifier: _pageIndexNotifier,
        modalTypeBuilder: (context) => WoltModalType.bottomSheet(),
        pageListBuilder: (modalSheetContext) {
          return [
            WoltModalSheetPage(
              topBarTitle: Text(
                l10n.signInWithCode,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              isTopBarLayerAlwaysVisible: true,
              trailingNavBarWidget: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Gaimon.selection();
                  Navigator.of(modalSheetContext).pop();
                },
              ),
              child: const _SignInModalContent(),
            ),
          ];
        },
      );

  void _showGenerateAccountModal(BuildContext context) =>
      WoltModalSheet.show<void>(
        context: context,
        pageIndexNotifier: _pageIndexNotifier,
        modalTypeBuilder: (context) => WoltModalType.bottomSheet(),
        pageListBuilder: (modalSheetContext) {
          return [
            WoltModalSheetPage(
              isTopBarLayerAlwaysVisible: true,
              trailingNavBarWidget: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Gaimon.selection();
                  Navigator.of(modalSheetContext).pop();
                },
              ),
              child: const _GenerateAccountModalContent(),
            ),
          ];
        },
      );
}

class _AnimatedLogo extends StatelessWidget {
  const _AnimatedLogo({required this.pulseController});

  final AnimationController pulseController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Animate(
      effects: const [
        FadeEffect(
          duration: Duration(milliseconds: 600),
          curve: Curves.easeOut,
        ),
        ScaleEffect(
          begin: Offset(0.8, 0.8),
          curve: Curves.elasticOut,
          duration: Duration(milliseconds: 800),
        ),
      ],
      child: AnimatedBuilder(
        animation: pulseController,
        builder: (context, child) {
          final scale = 1.0 + (pulseController.value * 0.05);
          return Transform.scale(scale: scale, child: child);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const FlutterLogo(size: 80),
        ),
      ),
    );
  }
}

class _AuthOptionCard extends StatelessWidget {
  const _AuthOptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final Gradient gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (gradient as LinearGradient).colors.first.withValues(
                  alpha: 0.3,
                ),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white70,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    ).animate().scale(duration: 200.ms, begin: const Offset(1.03, 1.03));
  }
}

class _SignInModalContent extends StatefulWidget {
  const _SignInModalContent();

  @override
  State<_SignInModalContent> createState() => _SignInModalContentState();
}

class _SignInModalContentState extends State<_SignInModalContent> {
  final _codeController = TextEditingController(text: kDebugMode ? 'OR5E' : '');
  final _codeFocusNode = FocusNode();

  @override
  void dispose() {
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  void _signInWithCode(BuildContext context, String code, AppLocalizations l10n) {
    if (code.length != 5) {
      Gaimon.warning();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.pleaseEnterCode),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Text(
                l10n.enterCode,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.enterCodeDesc,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const Text('Enter code'),
            ],
          ).animate().fadeIn(duration: 300.ms),
        ],
      ),
    );
  }
}

class _GenerateAccountModalContent extends StatelessWidget {
  const _GenerateAccountModalContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.isLoading) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: Column(
                children: [
                  const SizedBox(height: 48),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 24),
                  Text(
                    'Creating your account...',
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            );
          } else if (authProvider.errorMessage != null) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Registration Failed',
                    style: theme.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      authProvider.errorMessage!,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => authProvider.register(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            );
          } else if (authProvider.token != null) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Icon(
                    Icons.check_circle,
                    size: 64,
                    color: Colors.green[400],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Account Created!',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Your Token:',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          authProvider.token!,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Generate New Account',
                    style: theme.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Icon(
                    Icons.rocket_launch_rounded,
                    size: 64,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Ready to Get Started?',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "We'll create a new account and a unique 5-character code "
                    'for you to sign in.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => authProvider.register(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      foregroundColor: theme.colorScheme.onSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    label: Text(
                      l10n.generateMyCode,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class _VersionBadge extends StatelessWidget {
  const _VersionBadge();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          context.l10n.version(Misc.getAppVersion()),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
