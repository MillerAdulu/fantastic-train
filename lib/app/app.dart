import 'package:demo25/l10n/gen/app_localizations.dart';
import 'package:demo25/utils/router/router.dart';
import 'package:demo25/utils/singletons.dart';
import 'package:demo25/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

class FCDemo25 extends StatefulWidget {
  const FCDemo25({super.key});

  @override
  State<FCDemo25> createState() => _FCDemo25State();
}

class _FCDemo25State extends State<FCDemo25> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: FCTheme.light(context),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: getIt<FCRouter>().config(),
    );
  }
}
