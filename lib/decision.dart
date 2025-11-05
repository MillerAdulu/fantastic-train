import 'package:auto_route/auto_route.dart';
import 'package:demo25/services/local_storage/hive/hive_service.dart';
import 'package:demo25/utils/misc.dart';
import 'package:demo25/utils/router/router.dart';
import 'package:demo25/utils/singletons.dart';
import 'package:flutter/material.dart';

@RoutePage()
class DecisionPage extends StatefulWidget {
  const DecisionPage({super.key});

  @override
  State<DecisionPage> createState() => _DecisionPageState();
}

class _DecisionPageState extends State<DecisionPage> {
  @override
  void initState() {
    super.initState();
    final accessToken = getIt<HiveService>().auth.retrieveToken();

    if (accessToken == null) {
      _redirectToPage(context, FCRouter.signInRoute);
      return;
    }

    _redirectToPage(context, FCRouter.landing);
  }

  void _redirectToPage(BuildContext context, String routeName) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.router.pushPath(routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) =>
          Misc.exitApp(context: context, didPop: didPop, result: result),
      child: const Scaffold(
        body: Center(
          child: FlutterLogo(size: 222),
        ),
      ),
    );
  }
}
