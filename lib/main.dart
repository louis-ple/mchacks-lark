// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctxt) {
    return new MaterialApp(
      home: new FirstScreen(),
    );
  }
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build (BuildContext ctxt) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Multi Page Application"),
        ),
        body: Column(
          children: <Widget>[
            new Checkbox(
                value: false,
                onChanged: (bool newValue) {
                  Navigator.push(
                    ctxt,
                    new MaterialPageRoute(builder: (ctxt) => new ServerScreen()),
                  );
                }
            ),
            new Checkbox(
                value: false,
                onChanged: (bool newValue) {
                  Navigator.push(
                    ctxt,
                    new MaterialPageRoute(builder: (ctxt) => new TableScreen()),
                  );
                }
            )
          ]
        ),
    );
  }
}

class ServerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ServerScreenImpl();
  }
}

class ServerScreenImpl extends State<ServerScreen> {
  TextEditingController _textFieldController = TextEditingController();

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('TextField in Dialog'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "TextField in Dialog"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build (BuildContext ctxt) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Server List"),
        ),
        body: Column(
          children: <Widget>[
            Text("Hello World"),
            Text("Hello Flutter")
          ]
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _displayDialog(context),
        ),
    );
  }
}

class TableScreen extends StatelessWidget {
  @override
  Widget build (BuildContext ctxt) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Table List"),
        ),
        body: new Checkbox(
            value: false,
            onChanged: (bool newValue) {
              Navigator.pop(ctxt); // Pop from stack
            }
        )
    );
  }
}