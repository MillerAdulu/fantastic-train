import 'package:demo25/app/app.dart';
import 'package:demo25/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
