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

class ServerScreen extends StatelessWidget {
  @override
  Widget build (BuildContext ctxt) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Server List"),
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