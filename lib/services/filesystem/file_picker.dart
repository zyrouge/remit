import 'dart:async';
import 'dart:io';
import 'package:file_selector/file_selector.dart' as fs;
import 'package:remit/exports.dart';

class RuiPickedFile extends RemitFile {
  RuiPickedFile(this._file);

  final fs.XFile _file;

  @override
  Stream<List<int>> openRead([final int? start, final int? end]) {
    if (Platform.isLinux || Platform.isWindows || Platform.isAndroid) {
      return File(_file.path).openRead();
    }
    throw UnimplementedError();
  }

  @override
  StreamSink<List<int>> openWrite() {
    throw UnsupportedError('Picked files cannot perform write operation');
  }

  @override
  Future<int> size() => _file.length();

  @override
  String get basename => _file.name;
}

abstract class RuiFilePicker {
  static Future<List<RuiPickedFile>> pick() async {
    final List<fs.XFile> results = await fs.openFiles();
    return results.map((final fs.XFile x) => RuiPickedFile(x)).toList();
  }
}
