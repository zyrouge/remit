import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'remitx_native_platform_interface.dart';

/// An implementation of [RemitxNativePlatform] that uses method channels.
class MethodChannelRemitxNative extends RemitxNativePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('remitx_native');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
