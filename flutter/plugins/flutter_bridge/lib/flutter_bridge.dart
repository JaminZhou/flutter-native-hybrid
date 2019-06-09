import 'dart:async';

import 'package:flutter/services.dart';

class FlutterBridge {
  static const MethodChannel _channel =
      const MethodChannel('flutter_bridge');

  static Future<String> get userName async {
    final String version = await _channel.invokeMethod('getUserName');
    return version;
  }

  static Future<String> get appVersion async {
    final String version = await _channel.invokeMethod('getAppVersion');
    return version;
  }

  static Future<Map> request(String path, [String method='GET', Map<String, dynamic> parameter=const {}]) async {
    var result = await _channel.invokeMethod('request', [path, method, parameter]);
    return result;
  }
}
