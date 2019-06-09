import 'package:flutter/material.dart';
import 'base.dart';
import 'action.dart';

class FlutterPage1 extends StatefulWidget {
  @override
  _FlutterPage1State createState() => _FlutterPage1State();
}

class _FlutterPage1State extends State {
  final title = 'Flutter Page 1';

  var userName = '';

  void loadData() {
    Action.userName.then((val) => setState(() {
      userName = val;
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
      backgroundColor: Colors.orangeAccent,
      appBar: appBar,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Text('User Name: ' + userName),
        ),
      ),
    );
  }
}