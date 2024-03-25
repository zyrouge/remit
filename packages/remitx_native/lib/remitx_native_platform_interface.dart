import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'remitx_native_method_channel.dart';

abstract class RemitxNativePlatform extends PlatformInterface {
  /// Constructs a RemitxNativePlatform.
  RemitxNativePlatform() : super(token: _token);

  static final Object _token = Object();

  static RemitxNativePlatform _instance = MethodChannelRemitxNative();

  /// The default instance of [RemitxNativePlatform] to use.
  ///
  /// Defaults to [MethodChannelRemitxNative].
  static RemitxNativePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [RemitxNativePlatform] when
  /// they register themselves.
  static set instance(RemitxNativePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
