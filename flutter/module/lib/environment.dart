import 'package:flutter/material.dart';
import 'flutter_page1.dart';
import 'flutter_page2.dart';

enum Environment { DEVELOPMENT, PRODUCTION }

final Map<String, Widget> widgetMap = {
  'flutter_page1': FlutterPage1(),
  'flutter_page2': FlutterPage2(),
};

class Settings {
  Settings._();

  static Environment environment = Environment.PRODUCTION;

  static bool get isDev => environment == Environment.DEVELOPMENT;
}
