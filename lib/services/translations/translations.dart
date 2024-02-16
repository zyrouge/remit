import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'translation.dart';

part 'translations_part.dart';

const String kDefaultLocaleCode = 'en';
late final RuiTranslation defaultTranslation;

Future<RuiTranslation> _resolveTranslation(final String locale) async {
  final String content =
      await rootBundle.loadString('assets/i18n/$locale.json');
  final Map<dynamic, dynamic> json =
      jsonDecode(content) as Map<dynamic, dynamic>;
  return RuiTranslation(json.cast());
}

Future<RuiTranslation> _resolveTranslationOrDefault([
  final String? locale,
]) async {
  if (locale != null && RuiTranslations.localeCodes.contains(locale)) {
    return _resolveTranslation(locale);
  }
  return _resolveTranslation(kDefaultLocaleCode);
}
