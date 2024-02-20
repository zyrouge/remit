// ignore_for_file: avoid_print

import 'package:remit/exports.dart';

class Log extends RemitLogger {
  @override
  void info(final String tag, final String text) {
    print('$tag: $text');
  }

  @override
  void warn(final String tag, final String text) {
    print('$tag: $text');
  }

  @override
  void error(final String tag, final String text) {
    print('$tag: $text');
  }
}

final Log log = Log();
