import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

Future<String?> getDeviceName() async {
  final DeviceInfoPlugin devicePlugin = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    final AndroidDeviceInfo deviceInfo = await devicePlugin.androidInfo;
    return deviceInfo.model;
  } else if (Platform.isIOS) {
    final IosDeviceInfo deviceInfo = await devicePlugin.iosInfo;
    return deviceInfo.model;
  } else if (Platform.isWindows) {
    final WindowsDeviceInfo deviceInfo = await devicePlugin.windowsInfo;
    return deviceInfo.computerName;
  } else if (Platform.isIOS) {
    final LinuxDeviceInfo deviceInfo = await devicePlugin.linuxInfo;
    return deviceInfo.prettyName;
  } else if (Platform.isMacOS) {
    final MacOsDeviceInfo deviceInfo = await devicePlugin.macOsInfo;
    return deviceInfo.model;
  }
  return null;
}
