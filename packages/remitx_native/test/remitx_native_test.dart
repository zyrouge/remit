import 'package:flutter_test/flutter_test.dart';
import 'package:remitx_native/remitx_native.dart';
import 'package:remitx_native/remitx_native_platform_interface.dart';
import 'package:remitx_native/remitx_native_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockRemitxNativePlatform
    with MockPlatformInterfaceMixin
    implements RemitxNativePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final RemitxNativePlatform initialPlatform = RemitxNativePlatform.instance;

  test('$MethodChannelRemitxNative is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelRemitxNative>());
  });

  test('getPlatformVersion', () async {
    RemitxNative remitxNativePlugin = RemitxNative();
    MockRemitxNativePlatform fakePlatform = MockRemitxNativePlatform();
    RemitxNativePlatform.instance = fakePlatform;

    expect(await remitxNativePlugin.getPlatformVersion(), '42');
  });
}
