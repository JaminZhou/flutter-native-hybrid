import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bridge/flutter_bridge.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_bridge');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getAppVersion', () async {
    expect(await FlutterBridge.appVersion, '42');
  });
}
