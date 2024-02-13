import 'paths.dart';
import 'settings/settings.dart';

abstract class RuiIgnition {
  static bool ready = false;

  static Future<void> initialize(final void Function() onReady) async {
    await RuiPaths.initialize();
    await RuiSettings.initialize();
    ready = true;
    onReady();
  }
}
