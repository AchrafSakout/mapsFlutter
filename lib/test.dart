import 'package:flutter/material.dart';

class CounterPage extends StatefulWidget {
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int count = 12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Widget Communication")),
      body: Column(
        children: [
          Center(
              child: Count(
            count: count,
            onCountSelected: () {
              print("Count was selected.");
            },
          )),
          Container(
              color: Colors.amber,
              child: TextButton(onPressed: () {}, child: Text("data"))),
        ],
      ),
    );
  }
}

class Count extends StatelessWidget {
  final int count;
  final VoidCallback onCountSelected;

  Count({
    @required this.count,
    this.onCountSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text("$count"),
      onPressed: () => onCountSelected(),
    );
  }
}
