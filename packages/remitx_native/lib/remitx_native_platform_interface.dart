import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'remitx_native_method_channel.dart';

abstract class RemitxNativePlatform extends PlatformInterface {
  RemitxNativePlatform() : super(token: _token);

  Future<String?> openFilePicker() {
    throw UnimplementedError('openFilePicker() is not implemented');
  }

  Future<String?> openFolderPicker() {
    throw UnimplementedError('openFolderPicker() is not implemented');
  }

  Future<Map<dynamic, dynamic>?> statFileUri(final String uri) {
    throw UnimplementedError('statFileUri() is not implemented');
  }

  Future<Map<dynamic, dynamic>?> statFolderUri(final String uri) {
    throw UnimplementedError('statFolderUri() is not implemented');
  }

  Future<List<Map<dynamic, dynamic>>?> listFolderUri(final String uri) {
    throw UnimplementedError('listFolderUri() is not implemented');
  }

  static const Object _token = Object();

  static RemitxNativePlatform _instance = MethodChannelRemitxNative();

  static RemitxNativePlatform get instance => _instance;

  static set instance(final RemitxNativePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}
