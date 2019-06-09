import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

abstract class JZBaseWidget<A extends Widget, I extends Widget> extends StatelessWidget {
  A createAndroidWidget(BuildContext context);

  I createIOSWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return createIOSWidget(context);
    }
    return createAndroidWidget(context);
  }
}

class JZBaseApp extends JZBaseWidget<MaterialApp, CupertinoApp> {
  final Widget home;
  final TransitionBuilder builder;
  final debugShowCheckedModeBanner;

  JZBaseApp({
    this.home,
    this.builder,
    this.debugShowCheckedModeBanner = false,
  });

  @override
  MaterialApp createAndroidWidget(BuildContext context) {
    return MaterialApp(
      builder: builder,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      home: home,
    );
  }

  @override
  CupertinoApp createIOSWidget(BuildContext context) {
    return CupertinoApp(
      builder: builder,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      home: home,
    );
  }
}

class JZBaseScaffold extends JZBaseWidget<Scaffold, CupertinoPageScaffold> {
  final JZBaseAppBar appBar;
  final Widget body;
  final Color backgroundColor;

  JZBaseScaffold({
    this.appBar,
    this.body,
    this.backgroundColor = const Color(0xfff5f5f5),
  });

  @override
  Scaffold createAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: appBar.createAndroidWidget(context),
      body: body,
      backgroundColor: backgroundColor,
    );
  }

  @override
  CupertinoPageScaffold createIOSWidget(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: appBar.createIOSWidget(context),
      child: body,
      backgroundColor: backgroundColor,
    );
  }
}

class JZBaseAppBar extends JZBaseWidget<AppBar, CupertinoNavigationBar> {
  final Widget title;
  final Widget leading;

  JZBaseAppBar({
    this.title,
    this.leading,
  });

  @override
  AppBar createAndroidWidget(BuildContext context) {
    return AppBar(
      title: title,
      leading: leading,

      //default
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: Colors.white,
    );
  }

  @override
  CupertinoNavigationBar createIOSWidget(BuildContext context) {
    return CupertinoNavigationBar(
      middle: title,
      leading: leading,

      //default
      backgroundColor: Color(0xfeffffff),//当设置背景色设为不透明的时候会出现错误，所以曲线救国保留一点透明度 SafeArea show a wrong top padding with CupertinoApp https://github.com/flutter/flutter/issues/29136
    );
  }
}

class JZBaseButton extends JZBaseWidget<FlatButton, CupertinoButton> {
  final VoidCallback onPressed;
  final Widget child;
  final Color color;
  final double minSize;
  final BorderRadius borderRadius;
  final EdgeInsets padding;

  JZBaseButton({
    this.onPressed,
    this.child,
    this.color,
    this.minSize = 44.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(0.0)),
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  FlatButton createAndroidWidget(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: child,
      color: color,

      //default
      splashColor: Color(0),
    );
  }

  @override
  CupertinoButton createIOSWidget(BuildContext context) {
    return CupertinoButton(
      child: child,
      onPressed: onPressed,
      color: color,
      minSize: minSize,
      borderRadius: borderRadius,
      padding: padding,
    );
  }
}

class JZBaseAlertDialog extends JZBaseWidget<AlertDialog, CupertinoAlertDialog> {
  final Widget title;
  final Widget content;
  final List<Widget> actions;

  JZBaseAlertDialog({
    this.title,
    this.content,
    this.actions
  });

  @override
  AlertDialog createAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: actions,
    );
  }

  @override
  CupertinoAlertDialog createIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: title,
      content: content,
      actions: actions,
    );
  }
}

class JZBaseSwicth extends JZBaseWidget<Switch, CupertinoSwitch> {
  final bool value;
  final ValueChanged<bool> onChanged;

  JZBaseSwicth({
    this.value,
    this.onChanged
  });

  @override
  Switch createAndroidWidget(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
    );
  }

  @override
  CupertinoSwitch createIOSWidget(BuildContext context) {
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
    );
  }
}

class JZBaseBackButton extends JZBaseButton {
  final void Function() onPressed;

  static Widget backChild() {
    if (Platform.isIOS) {
      return Container(
        width: 44.0,
        alignment: Alignment.centerLeft,
        child: Image(image:AssetImage("images/icon_back.png")),
      );
    }
    return Image(image:AssetImage("images/icon_back.png"));
  }

  JZBaseBackButton({
    this.onPressed,
  }): super (
    child: backChild(),
    onPressed: () => onPressed,
    minSize: 0.0,
    padding: EdgeInsets.all(0.0),
  );
}

Future<T> showJZBaseDialog<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
}) {
  if (Platform.isIOS) {
    return showCupertinoDialog(
      context: context,
      builder: builder,
    );
  } else {
    return showDialog(
      context: context,
      builder: builder,
    );
  }
}

PageRoute showJZBasePageRoute({
  @required WidgetBuilder builder,
}) {
  if (Platform.isIOS) {
    return CupertinoPageRoute(
      builder: builder,
    );
  } else {
    return MaterialPageRoute(
      builder: builder,
    );
  }
}

