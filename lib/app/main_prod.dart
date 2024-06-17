import 'package:weather/config/flavors.dart';
import 'package:weather/main.dart' as runner;

Future<void> main() async {
  F.appFlavor = Flavor.prod;
  await runner.main();
}
