import 'package:auto_route/auto_route.dart';
import 'package:demo25/features/auth/cubit/register_cubit.dart';
import 'package:demo25/features/auth/cubit/sign_in_cubit.dart';
import 'package:demo25/l10n/l10n.dart';
import 'package:demo25/shared_widgets/credentials/credentials.dart';
import 'package:demo25/utils/misc.dart';
import 'package:demo25/utils/router/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:pinput/pinput.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SignInHandset extends StatefulWidget {
  const SignInHandset({super.key});

  @override
  State<SignInHandset> createState() => _SignInHandsetState();
}

class _SignInHandsetState extends State<SignInHandset>
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
              child:
                  Column(
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
                            'Your journey starts here',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 48),

                          _AuthOptionCard(
                            icon: Icons.qr_code_scanner_rounded,
                            title: 'I Have a Code',
                            description: 'Continue using your 5-character code',
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.primary.withValues(
                                  alpha: 0.7,
                                ),
                              ],
                            ),
                            onTap: () {
                              Gaimon.selection();
                              _showCodeInputModal(context);
                            },
                          ),
                          const SizedBox(height: 16),
                          _AuthOptionCard(
                            icon: Icons.auto_awesome_rounded,
                            title: 'Generate New Code',
                            description: 'Create a fresh account instantly',
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.secondary,
                                theme.colorScheme.secondary.withValues(
                                  alpha: 0.7,
                                ),
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

  void _showCodeInputModal(BuildContext context) {
    WoltModalSheet.show<void>(
      context: context,
      pageIndexNotifier: _pageIndexNotifier,
      modalTypeBuilder: (context) => WoltModalType.bottomSheet(),
      pageListBuilder: (modalSheetContext) {
        return [
          WoltModalSheetPage(
            topBarTitle: Text(
              'Sign In With Code',
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
  }

  void _showGenerateAccountModal(BuildContext context) {
    WoltModalSheet.show<void>(
      context: context,
      pageIndexNotifier: _pageIndexNotifier,
      modalTypeBuilder: (context) => WoltModalType.bottomSheet(),
      pageListBuilder: (modalSheetContext) {
        return [
          WoltModalSheetPage(
            // The title is now handled by the content to be dynamic.
            isTopBarLayerAlwaysVisible: true,
            trailingNavBarWidget: BlocBuilder<RegisterCubit, RegisterState>(
              builder: (context, state) => state.maybeWhen(
                loading: () => const SizedBox.shrink(),
                orElse: () => IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Gaimon.selection();
                    Navigator.of(modalSheetContext).pop();
                  },
                ),
              ),
            ),
            child: const _GenerateAccountModalContent(),
          ),
        ];
      },
    );
  }
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
          child: const FlutterLogo(size: 96),
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

  void _signInWithCode(BuildContext context, String code) {
    if (code.length != 5) {
      Gaimon.warning();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text('Please enter a valid 5-character code.'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }
    context.read<SignInCubit>().signIn(code: code.trim().toUpperCase());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      child: BlocConsumer<SignInCubit, SignInState>(
        listener: (context, state) {
          state.maybeWhen(
            loaded: () {
              Gaimon.success();
              Navigator.of(context).pop(); // Close modal on success
              context.router.pushPath(FCRouter.landing);
            },
            error: (message) {
              Gaimon.error();
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: theme.colorScheme.error,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
            },
            orElse: () {},
          );
        },
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            state.maybeWhen(
              loading: () => const _LoadingView(
                message: 'Verifying your code...',
              ),
              orElse: () => Column(
                children: [
                  Text(
                    'Enter Your 5-Character Code',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This was provided when you registered.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Pinput(
                    focusNode: _codeFocusNode,
                    length: 5,
                    controller: _codeController,
                    autofocus: true,
                    textCapitalization: TextCapitalization.characters,
                    defaultPinTheme: PinTheme(
                      width: 56,
                      height: 60,
                      textStyle: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 56,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.2,
                            ),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    onCompleted: (value) => _signInWithCode(context, value),
                  ),
                ],
              ).animate().fadeIn(duration: 300.ms),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenerateAccountModalContent extends StatelessWidget {
  const _GenerateAccountModalContent();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        state.maybeWhen(
          loaded: (user) {
            Gaimon.success();
            // Don't pop, the UI will rebuild to the success state.
          },
          error: (message) {
            Gaimon.error();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: state.maybeWhen(
            orElse: () => const _GenerateAccountInitialView(),
            loading: () => const _LoadingView(
              message: 'Creating your account...',
            ),
            loaded: (user) => GenerateAccountSuccessView(email: user.email),
          ),
        );
      },
    );
  }
}

class _GenerateAccountInitialView extends StatelessWidget {
  const _GenerateAccountInitialView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            onPressed: () {
              Gaimon.selection();
              context.read<RegisterCubit>().register();
            },
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
              'Generate My Code',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ).animate().fadeIn(duration: 300.ms),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(height: 48),
        const CircularProgressIndicator(),
        const SizedBox(height: 24),
        Text(
          message,
          style: theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
      ],
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
