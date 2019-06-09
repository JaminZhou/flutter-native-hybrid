import 'package:flutter/material.dart';
import 'base.dart';
import 'environment.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Settings.environment = Environment.DEVELOPMENT;
    return JZBaseApp(home: testWidget());
  }
}

Widget testWidget() {
  return JZBaseScaffold(
    appBar: JZBaseAppBar(
      title: Text('Flutter Dev', style: TextStyle(color: Colors.black)),
    ),
    body: createTestListView(),
  );
}

Widget createTestListView() {
  List<TestItem> list = [];
  void generatePageBuilders(String key, Widget value) {
    list.add(TestItem(title: key, page: value));
  }
  widgetMap.forEach(generatePageBuilders);

  return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  width: 1.0,
                  color: Color(0xfff5f5f5),
                ),
              ),
            ),
            child: Container(
              margin: EdgeInsets.only(left: 16),
              alignment: Alignment.centerLeft,
              child: Text(list[index].title),
            ),
          ),
          onTap: () => tapItem(context, list[index].page),
        );
      });
}

void tapItem(BuildContext context, Widget page) {
  Navigator.push(
    context,
    showJZBasePageRoute(builder: (context) => page),
  );
}

class TestItem {
  final String title;
  final Widget page;

  TestItem({
    @required this.title,
    @required this.page,
  });
}
