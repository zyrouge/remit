import 'remitx_native_platform_interface.dart';

class RemitxNative {
  Future<String?> openFilePicker() =>
      RemitxNativePlatform.instance.openFilePicker();

  Future<String?> openFolderPicker() =>
      RemitxNativePlatform.instance.openFolderPicker();

  Future<Map<dynamic, dynamic>?> statFileUri(final String uri) =>
      RemitxNativePlatform.instance.statFileUri(uri);

  Future<Map<dynamic, dynamic>?> statFolderUri(final String uri) =>
      RemitxNativePlatform.instance.statFolderUri(uri);

  Future<List<Map<dynamic, dynamic>>?> listFolderUri(final String uri) =>
      RemitxNativePlatform.instance.listFolderUri(uri);
}
