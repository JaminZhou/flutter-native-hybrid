import 'package:flutter/material.dart';
import 'base.dart';
import 'action.dart';

class FlutterPage2 extends StatefulWidget {
  @override
  _FlutterPage2State createState() => _FlutterPage2State();
}

class _FlutterPage2State extends State {
  final title = 'Flutter Page 2';

  var appVersion = '';

  void loadData() {
    Action.appVersion.then((val) => setState(() {
      appVersion = val;
    }));
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var backButton = JZBaseBackButton(
      onPressed: () => Action.closePage(context),
    );

    var appBar = JZBaseAppBar(
      title: Text(title, style: TextStyle(color: Colors.black)),
      leading: backButton,
    );

    return JZBaseScaffold(
      backgroundColor: Colors.amberAccent,
      appBar: appBar,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Text('App Version: ' + appVersion),
        ),
      ),
    );
  }
}