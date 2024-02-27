part 'translation_part.dart';

String _stringFormat(final String template, final List<String> values) {
  final StringBuffer buffer = StringBuffer();
  for (int i = 0; i < template.length; i++) {
    final String x = template[i];
    if (x == '%' && template[i + 1] != '%') {
      final int n = int.parse(template[i + 1]);
      buffer.write(values[n]);
      i += 3;
      continue;
    }
    buffer.write(x);
  }
  return buffer.toString();
}
