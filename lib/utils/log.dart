// ignore_for_file: avoid_print

abstract class Log {
  static void info(final String tag, final String text) {
    print('$tag: $text');
  }

  static void warn(final String tag, final String text) {
    print('$tag: $text');
  }

  static void error(final String tag, final String text) {
    print('$tag: $text');
  }
}
