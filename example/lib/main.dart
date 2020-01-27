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
              theme: const RolodexThemeData(
//                direction: RolodexDirection.reversed,
//                cardColor: Colors.black,
                clipBorderRadius: BorderRadius.all(Radius.circular(10)),
//                alwaysShowBackground: true,
//                cardFallDirection: AxisDirection.left,
//                cardStackAlignment: AlignmentDirectional.centerEnd,
              ),
              value: counter,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text("$counter", style: TextStyle(fontSize: 40)
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for(var c in "$counter".split("").asMap().entries)
                    Rolodex(
                      key: ValueKey("$counter".length-c.key),
                      value: c.value,
                      theme: const RolodexThemeData(
                        mode: RolodexMode.splitFlap,
                        direction: RolodexDirection.forward,
                      ),
                      child: Text(c.value, style: TextStyle(fontSize: 40))
                    ),
                ],
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
