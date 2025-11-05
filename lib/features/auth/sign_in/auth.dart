import 'package:demo25/features/auth/sign_in/_handset.dart';
import 'package:demo25/features/auth/sign_in/_handset_cubit.dart';
import 'package:demo25/features/auth/sign_in/_handset_provider.dart';
import 'package:demo25/features/auth/sign_in/_handset_setstate.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => const FCSignInHandsetCubit(),
    );
  }
}
