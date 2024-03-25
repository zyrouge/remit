import '../services/translations/translation.dart';

String bytesToString(final RuiTranslation t, final int bytes) {
  final double kb = bytes / 1024;
  if (kb < 1000) {
    return t.xKb(kb.toStringAsFixed(1));
  }
  final double mb = kb / 1024;
  if (mb < 1000) {
    return t.xMb(mb.toStringAsFixed(2));
  }
  final double gb = mb / 1024;
  return t.xGb(gb.toStringAsFixed(2));
}
