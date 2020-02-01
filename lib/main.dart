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
  final List<String> entries = <String>['Annie', 'Alex', 'Carolyn'];

  _displayDialog(BuildContext context) async {
    await(showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Server'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Server Name"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('ADD'),
                onPressed: () {
                  entries.add(_textFieldController.text);
                  setState((){});
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        })
    ).then((value) {
      _textFieldController.clear();
    });
  }

  @override
  Widget build (BuildContext ctxt) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Server List"),
        ),
        body: new ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 50,
                child: Center(child: Text(entries[index])),
              );
            }
          ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _displayDialog(context),
        ),
    );
  }
}

class TableScreen extends StatefulWidget{
  TableScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Tables createState() => _Tables();
}

// The base class for the different types of items the list can contain.
class Table {
  int id;
  Table(this.id);
}

class _Tables extends State<TableScreen> {

  Table table1 = new Table(1);
  Table table2 = new Table(2);
  Table table3 = new Table(3);

  int _nb_tables = 0;
  final List<Table> tables = <Table>[];
  final TextEditingController eCtrl = TextEditingController();

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Enter table number:"),
          content: TextField(
            controller: eCtrl,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new MaterialButton(
              child:  Text("Add"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addTable() {

    _showDialog();

    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _nb_tables++;
    });
  }

  @override
  Widget build (BuildContext context) {

    final title = 'Table list';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(100, (index) {
            return Center(
              child: Text(
                'Table $index',
                style: Theme.of(context).textTheme.headline,
              ),
            );
          }),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: _addTable,
          tooltip: 'Add a table',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

//