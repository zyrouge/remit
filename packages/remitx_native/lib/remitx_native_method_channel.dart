import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'remitx_native_platform_interface.dart';

class MethodChannelRemitxNative extends RemitxNativePlatform {
  @visibleForTesting
  final MethodChannel methodChannel = const MethodChannel('remitx_native');

  @override
  Future<String?> openFilePicker() =>
      methodChannel.invokeMethod('openFilePicker');

  @override
  Future<String?> openFolderPicker() =>
      methodChannel.invokeMethod('openFolderPicker');

  @override
  Future<Map<dynamic, dynamic>?> statFileUri(final String uri) {
    final Map<dynamic, dynamic> arguments = <dynamic, dynamic>{'uri': uri};
    return methodChannel.invokeMethod('statFileUri', arguments);
  }

  @override
  Future<Map<dynamic, dynamic>?> statFolderUri(final String uri) {
    final Map<dynamic, dynamic> arguments = <dynamic, dynamic>{'uri': uri};
    return methodChannel.invokeMethod('statFolderUri', arguments);
  }

  @override
  Future<List<Map<dynamic, dynamic>>?> listFolderUri(final String uri) {
    final Map<dynamic, dynamic> arguments = <dynamic, dynamic>{'uri': uri};
    return methodChannel.invokeListMethod('listFolderUri', arguments);
  }
}
