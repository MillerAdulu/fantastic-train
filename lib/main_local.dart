import 'package:demo25/app/app.dart';
import 'package:demo25/bootstrap.dart';
import 'package:demo25/utils/constants.dart';
import 'package:demo25/utils/singletons.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FCConfig(
    values: FCValues(
      baseDomain: 'flutterconke.fly.dev', // If the API resides on your computer
      urlScheme: 'https',
      hiveBox: 'demo25Box-local',
    ),
  );

  // Force portrait like on Instagram
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) async => bootstrap(
      () =>   MultiBlocProvider(
        providers: Singletons.registerCubits(),
        child: const FCDemo25(),
      ),
    ),
  );
}
