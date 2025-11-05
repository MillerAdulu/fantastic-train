import 'package:demo25/features/auth/cubit/register_cubit.dart';
import 'package:demo25/features/auth/cubit/sign_in_cubit.dart';
import 'package:demo25/features/landing/cubit/get_widgets_cubit.dart';
import 'package:demo25/services/api/auth_service.dart';
import 'package:demo25/services/api/widget_service.dart';
import 'package:demo25/services/local_storage/hive/hive_service.dart';
import 'package:demo25/services/local_storage/isar/isar_service.dart';
import 'package:demo25/utils/router/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';

final GetIt getIt = GetIt.instance;
late Isar prfDBInstance;

class Singletons {
  static void setup() {
    getIt
      ..registerSingleton<FCRouter>(FCRouter())
      ..registerSingleton<HiveService>(HiveService())
      ..registerSingleton<IsarService>(IsarService())
      ..registerSingleton<WidgetService>(WidgetService())
      ..registerSingleton<AuthService>(AuthService());
  }

  static Future<void> setupDatabases() async {
    await getIt<HiveService>().initBoxes();
    await getIt<IsarService>().initDatabase();
  }

  static List<BlocProvider> registerCubits() {
    return <BlocProvider>[
      BlocProvider<SignInCubit>(
        create: (context) => SignInCubit(
          authService: getIt(),
          hiveService: getIt(),
        ),
      ),

      BlocProvider<RegisterCubit>(
        create: (context) => RegisterCubit(
          authService: getIt(),
          hiveService: getIt(),
        ),
      ),

      BlocProvider<GetWidgetsCubit>(
        create: (context) => GetWidgetsCubit(
          widgetService: getIt(),
          isarService: getIt(),
        ),
      ),
    ];
  }
}
