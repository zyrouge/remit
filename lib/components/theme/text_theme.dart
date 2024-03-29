import 'package:flutter/widgets.dart';

class RuiTextTheme {
  const RuiTextTheme({
    required this.display,
    required this.headline,
    required this.title,
    required this.body,
    required this.small,
  });

  final TextStyle display;
  final TextStyle headline;
  final TextStyle title;
  final TextStyle body;
  final TextStyle small;

  static const String fontFamily = 'Inter';

  static const RuiTextTheme standard = RuiTextTheme(
    display: TextStyle(
      fontFamily: fontFamily,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    headline: TextStyle(
      fontFamily: fontFamily,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    title: TextStyle(
      fontFamily: fontFamily,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    body: TextStyle(fontFamily: fontFamily, fontSize: 14),
    small: TextStyle(fontFamily: fontFamily, fontSize: 12),
  );
}
