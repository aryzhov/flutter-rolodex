import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rolodex/rolodex.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int counter = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final value = counter;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Rolodex Example'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Rolodex(
              value: value,
              builder: (context) => SizedBox(
                width: 100,
                height: 100,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("$value", style: TextStyle(fontSize: 40), softWrap: false, overflow: TextOverflow.fade,),
                  ),
                ),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text("Add"),
                  onPressed: () {
                    setState(() {
                      counter++;
                    });
                  },
                ),
                RaisedButton(
                  child: Text("Substract"),
                  onPressed: () {
                    setState(() {
                      counter--;
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
