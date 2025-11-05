import 'package:auto_route/auto_route.dart';
import 'package:demo25/utils/router/router.gr.dart';

@AutoRouterConfig()
class FCRouter extends RootStackRouter {
  // Auth
  static const String decisionRoute = '/';
  static const String signInRoute = '/sign-in';

  // Student Landing
  static const String landing = '/landing';
  static const String widgets = '/widgets';

  @override
  List<AutoRoute> get routes => [
    // Auth
    AutoRoute(page: DecisionRoute.page, path: decisionRoute),
    AutoRoute(page: SignInRoute.page, path: signInRoute),

    AutoRoute(page: LandingRoute.page, path: landing),
  ];
}
