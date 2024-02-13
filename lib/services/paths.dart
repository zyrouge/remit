import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../utils/log.dart';

abstract class RuiPaths {
  static late final Directory supportDirectory;

  static Future<void> initialize() async {
    supportDirectory = await path_provider.getApplicationSupportDirectory();
    if (!(await supportDirectory.exists())) {
      supportDirectory.create(recursive: true);
    }
    Log.info('Paths', 'initialized all paths');
  }
}
