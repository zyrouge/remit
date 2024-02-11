import 'package:flutter/widgets.dart';

class RuiTextTheme {
  const RuiTextTheme({
    required this.title,
    required this.body,
    required this.small,
  });

  final TextStyle title;
  final TextStyle body;
  final TextStyle small;

  static const RuiTextTheme standard = RuiTextTheme(
    title: TextStyle(fontSize: 18),
    body: TextStyle(fontSize: 14),
    small: TextStyle(fontSize: 10),
  );
}
