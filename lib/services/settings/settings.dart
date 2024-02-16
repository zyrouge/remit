import 'dart:convert';
import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart' as p;
import '../paths.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

enum RuiThemeMode { light, dark }

@freezed
class RuiSettingsData with _$RuiSettingsData {
  const factory RuiSettingsData({
    final String? locale,
    @Default(RuiThemeMode.dark) final RuiThemeMode themeMode,
  }) = _RuiSettingsData;

  factory RuiSettingsData.fromJson(final Map<String, dynamic> json) =>
      _$RuiSettingsDataFromJson(json);
}

abstract class RuiSettings {
  static late RuiSettingsData settings;
  static void Function(RuiSettingsData)? onSettingsChange;

  static Future<void> initialize() async {
    settings = await read();
  }

  static Future<void> update(final RuiSettingsData data) async {
    await write(data);
    settings = data;
  }

  static Future<RuiSettingsData> read() async {
    try {
      final File file = File(filePath);
      final String content = await file.readAsString();
      final Map<String, dynamic> json =
          jsonDecode(content) as Map<String, dynamic>;
      return RuiSettingsData.fromJson(json);
    } catch (_) {}
    return const RuiSettingsData();
  }

  static Future<void> write(final RuiSettingsData data) async {
    final File file = File(filePath);
    final Map<String, dynamic> json = data.toJson();
    await file.writeAsString(jsonEncode(json));
  }

  static String get filePath =>
      p.join(RuiPaths.supportDirectory.absolute.path, 'settings.json');
}
