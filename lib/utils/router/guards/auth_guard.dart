import 'package:auto_route/auto_route.dart';
import 'package:demo25/services/local_storage/hive/hive_service.dart';
import 'package:demo25/utils/router/router.gr.dart';
import 'package:demo25/utils/singletons.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final token = getIt<HiveService>().auth.retrieveToken();
    final isLoggedOut = getIt<HiveService>().auth.isLoggedOut();

    if (token != null && !isLoggedOut) {
      resolver.next();
    } else {
      router.push(const DecisionRoute());
    }
  }
}
