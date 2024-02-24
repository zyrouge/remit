import 'package:flutter/widgets.dart';

abstract class RuiColors {
  static const Color transparent = Color(0x00000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // https://tailwindcss.com/docs/customizing-colors#default-color-palette
  static const Color red500 = Color(0xFFEF4444);
  static const Color red600 = Color(0xFFDC2626);

  // https://tailwindcss.com/docs/customizing-colors#default-color-palette
  static const Color blue400 = Color(0xFF2563Eb);
  static const Color blue500 = Color(0xFF1D4ED8);
  static const Color blue600 = Color(0xFF1E40AF);

  // https://www.tints.dev/dark/F5F5F5 (100/80-0)
  static const Color light100 = Color(0xFFF5F5F5);
  static const Color light200 = Color(0xFFD9D9D9);
  static const Color light300 = Color(0xFFBFBFBF);
  static const Color light400 = Color(0xFFA3A3A3);
  static const Color light500 = Color(0xFF878787);
  static const Color light600 = Color(0xFF6E6E6E);

  // https://www.tints.dev/dark/171717 (900/50-0)
  static const Color dark200 = Color(0xFF696969);
  static const Color dark300 = Color(0xFF5C5C5C);
  static const Color dark400 = Color(0xFF525252);
  static const Color dark500 = Color(0xFF454545);
  static const Color dark600 = Color(0xFF3B3B3B);
  static const Color dark700 = Color(0xFF2E2E2E);
  static const Color dark800 = Color(0xFF242424);
  static const Color dark900 = Color(0xFF171717);
}
