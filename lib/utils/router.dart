import 'package:demo25/features/auth/sign_in/auth.dart';
import 'package:flutter/widgets.dart';

class FCRouter {
  static String get initialRoute => '/';

  static Map<String, WidgetBuilder> get routes {
    return {
      initialRoute: (context) => const SignInPage(),
    };
  }
}
