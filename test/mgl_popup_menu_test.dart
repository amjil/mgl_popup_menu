import 'package:flutter_test/flutter_test.dart';
import 'package:mgl_popup_menu/mgl_popup_menu.dart';
import 'package:mgl_popup_menu/mgl_popup_menu_platform_interface.dart';
import 'package:mgl_popup_menu/mgl_popup_menu_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMglPopupMenuPlatform
    with MockPlatformInterfaceMixin
    implements MglPopupMenuPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MglPopupMenuPlatform initialPlatform = MglPopupMenuPlatform.instance;

  test('$MethodChannelMglPopupMenu is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMglPopupMenu>());
  });

  test('getPlatformVersion', () async {
    MglPopupMenu mglPopupMenuPlugin = MglPopupMenu();
    MockMglPopupMenuPlatform fakePlatform = MockMglPopupMenuPlatform();
    MglPopupMenuPlatform.instance = fakePlatform;

    expect(await mglPopupMenuPlugin.getPlatformVersion(), '42');
  });
}
