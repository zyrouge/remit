
import 'remitx_native_platform_interface.dart';

class RemitxNative {
  Future<String?> getPlatformVersion() {
    return RemitxNativePlatform.instance.getPlatformVersion();
  }
}
