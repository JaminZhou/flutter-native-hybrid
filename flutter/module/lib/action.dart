import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_bridge/flutter_bridge.dart';
import 'environment.dart';

class Action {
  static void closePage(BuildContext context) {
    if (Settings.isDev) {
      Navigator.pop(context);
    } else {
      FlutterBoost.singleton.closeCurPage({});
    }
  }

  static Future<String> get userName async {
    if (Settings.isDev) {
      return 'JaminZhou';
    } else {
      return FlutterBridge.userName;
    }
  }

  static Future<String> get appVersion async {
    if (Settings.isDev) {
      return '1.0';
    } else {
      return FlutterBridge.appVersion;
    }
  }

}