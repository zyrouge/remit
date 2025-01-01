// ignore_for_file: avoid_print

import 'package:remit/exports.dart';

class Log extends RemitLogger {
  @override
  void debug(
    final String tag,
    final String text, [
    final Object? err,
    final Object? stackTrace,
  ]) {
    print('DEBUG $tag: $text');
  }

  @override
  void info(
    final String tag,
    final String text, [
    final Object? err,
    final Object? stackTrace,
  ]) {
    print('INFO $tag: $text');
  }

  @override
  void warn(
    final String tag,
    final String text, [
    final Object? err,
    final Object? stackTrace,
  ]) {
    print('WARN $tag: $text');
    if (err != null) {
      print(err);
    }
    if (stackTrace != null) {
      print(stackTrace);
    }
  }

  @override
  void error(
    final String tag,
    final String text, [
    final Object? err,
    final Object? stackTrace,
  ]) {
    print('ERROR! $tag: $text');
    if (err != null) {
      print(err);
    }
    if (stackTrace != null) {
      print(stackTrace);
    }
  }
}

final Log log = Log();
