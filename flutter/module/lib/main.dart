import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'base.dart';
import 'environment.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Map<String, PageBuilder> pageBuilders = {};
    void generatePageBuilders(String key, Widget value) {
      pageBuilders[key] = (pageName, params, _) => value;
    }
    widgetMap.forEach(generatePageBuilders);
    FlutterBoost.singleton.registerPageBuilders(pageBuilders);
    FlutterBoost.handleOnStartPage();
  }

  @override
  Widget build(BuildContext context) {
    return JZBaseApp(
      builder: FlutterBoost.init(),
      home: Container(),
    );
  }
}
