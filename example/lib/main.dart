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
    final counterDigits = "$counter".padLeft(2, ' ').split('');
    return RolodexTheme(
      data: RolodexThemeData(),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Rolodex Example'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Rolodex(
                    theme: const RolodexThemeData(
                      cardColor: Colors.blue,
                      shadowColor: Colors.indigo,
                      clipBorderRadius: BorderRadius.all(Radius.circular(6)),
                      alwaysShowBackground: true,
                    ),
                    value: counter,
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: Center(
                        child: Text(
                          "$counter",
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        for (var c in counterDigits.asMap().entries)
                          Rolodex(
                              key: ValueKey(counterDigits.length - c.key),
                              value: c.value,
                              theme: const RolodexThemeData(
                                mode: RolodexMode.splitFlap,
                                direction: RolodexDirection.forward,
                              ),
                              child: SizedBox(
                                  width: 30,
//                            height: 42,
                                  child: Center(
                                      child: Text(c.value,
                                          style: TextStyle(fontSize: 40))))),
                      ],
                    ),
                  ),
                ],
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
      ),
    );
  }
}
