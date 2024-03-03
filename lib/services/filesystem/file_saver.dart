import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;

abstract class RuiFileSaver {
  static Future<void> makeDirectory(final String partialPath) async {
    final String dir = await getDestinationDir();
    final String outputPath = p.join(dir, partialPath);
    await Directory(outputPath).create(recursive: true);
  }

  static Future<void> saveFile(
    final String partialPath,
    final Stream<List<int>> inputStream,
    final void Function(int) onProgress,
  ) async {
    final String dir = await getDestinationDir();
    final String outputPath = p.join(dir, partialPath);
    final File outputFile = File(outputPath);
    await outputFile.create(recursive: true);
    final IOSink outputStream = outputFile.openWrite();
    int progress = 0;
    final Stream<List<int>> nInputStream = inputStream.map((final List<int> x) {
      progress += x.length;
      onProgress(progress);
      return x;
    });
    return outputStream.addStream(nInputStream);
  }

  static Future<String> getDestinationDir() async {
    final Directory? dir = await path_provider.getDownloadsDirectory();
    if (dir == null) {
      throw Exception('Unable to retrieve downloads directory');
    }
    return dir.path;
  }
}
