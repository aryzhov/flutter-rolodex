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
              value: counter,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: const Border.fromBorderSide(const BorderSide(color: Colors.grey)),
//                border: Border.all(color: Colors.grey),
                borderRadius: const BorderRadius.all(const Radius.circular(3.0)),
              ),
              builder: (context, value) => SizedBox(
                width: 40,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("$value", style: TextStyle(fontSize: 20), softWrap: false, overflow: TextOverflow.fade,),
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
