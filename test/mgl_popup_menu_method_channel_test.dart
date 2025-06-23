import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgl_popup_menu/mgl_popup_menu_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelMglPopupMenu platform = MethodChannelMglPopupMenu();
  const MethodChannel channel = MethodChannel('mgl_popup_menu');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
