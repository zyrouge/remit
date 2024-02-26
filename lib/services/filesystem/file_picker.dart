import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart' as fp;
import 'package:remit/exports.dart';

class RuiPickedFile extends RemitFile {
  RuiPickedFile(this._file);

  final fp.PlatformFile _file;

  @override
  Stream<List<int>> openRead([final int? start, final int? end]) {
    if (Platform.isLinux || Platform.isWindows || Platform.isAndroid) {
      return File(_file.path!).openRead();
    }
    throw UnimplementedError();
  }

  @override
  StreamSink<List<int>> openWrite() {
    throw UnsupportedError('Picked files cannot perform write operation');
  }

  @override
  int size() => _file.size;

  @override
  String get basename => _file.name;
}

abstract class RuiFilePicker {
  static Future<List<RuiPickedFile>> pick() async {
    final fp.FilePickerResult? result =
        await fp.FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) {
      return <RuiPickedFile>[];
    }
    return result.files
        .map((final fp.PlatformFile x) => RuiPickedFile(x))
        .toList();
  }
}
