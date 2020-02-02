// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctxt) {
    return new MaterialApp(
      home: new FirstScreen(),
    );
  }
}

class _Server {
  String name;
  final tables;
  final DocumentReference reference;

  _Server.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['tables'] != null),
        name = map['name'],
        tables = map['tables'];

  _Server.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Server<$name:$tables>";
}

class _Table {
  final _Server server;
  final int tableNumber;
  final DocumentReference reference;

  _Table.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['tableNumber'] != null),
        assert(map['server'] != null),
        server = map['server'],
        tableNumber = map['tableNumber'];

  _Table.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Table<$server:$tableNumber>";
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

  _displayAddDialog(BuildContext context) async {
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

  _displayEditDialog(BuildContext context, _Server server) async {
    await(showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Server'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Server Name"),
            ),
            actions: <Widget>[
//              new FlatButton(
//                child: new Text('DELETE'),
//                onPressed: () {
//                  entries.removeAt(index);
//                  setState((){});
//                  Navigator.of(context).pop();
//                },
//              ),
              new FlatButton(
                child: new Text('UPDATE'),
                onPressed: () {
                  server.name = _textFieldController.text;
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

  Widget _buildBody(BuildContext context) {
    Firestore db = Firestore.instance;
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection('servers').snapshots(),
      builder: (context, snapshot) {
        print("Snapshot: ${snapshot.toString()}");
        if (snapshot.hasData) return _buildList(context, snapshot.data.documents);

        return LinearProgressIndicator();
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final server = _Server.fromSnapshot(data);

    return Padding(
      key: ValueKey(server.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(server.name),
          trailing: Text(server.tables.toString()),
          onTap: () {
            _textFieldController.text = server.name;
            _displayEditDialog(context, server);
          },
        ),
      ),
    );
  }

  @override
  Widget build (BuildContext ctxt) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Server List"),
        ),
        body: _buildBody(context),
//        body: new ListView.builder(
//            padding: const EdgeInsets.all(8),
//            itemCount: entries.length,
//            itemBuilder: (BuildContext context, int index) {
//              return FlatButton(
//                child: Container(
//                  height: 50,
//                  child: Center(child: Text(entries[index])),
//                ),
//                onPressed: () {
//                  _textFieldController.text = entries[index];
//                  _displayEditDialog(context, index);
//                },
//              );
//            }
//          ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _displayAddDialog(context),
        ),
    );
  }
}

class TableScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TableScreenImpl();
  }
}

class TableScreenImpl extends State<TableScreen> {
  TextEditingController _tFCNumGuests = new TextEditingController();
  TextEditingController _tFCTableNum = new TextEditingController();
  final List<int> tables = <int>[1, 2, 3, 4, 5, 6, 7, 11, 12, 13, 14];

  _displayAddDialog(BuildContext context) async {
    await(showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Table'),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: _tFCNumGuests,
                  decoration: InputDecoration(hintText: "# of Guests", labelText: "Fits:"),
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _tFCTableNum,
                  decoration: InputDecoration(hintText: "#", labelText: "Table Number"),
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,
                )
              ]
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('ADD'),
                onPressed: () {
                  tables.add(int.parse(_tFCTableNum.text));
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
      _tFCNumGuests.clear();
      _tFCTableNum.clear();
    });
  }

  _displayEditDialog(BuildContext context, int index) async {
    await(showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Table'),
            content: Column(
                children: <Widget>[
                  TextField(
                    controller: _tFCNumGuests,
                    decoration: InputDecoration(hintText: "# of Guests", labelText: "Fits:"),
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _tFCTableNum,
                    decoration: InputDecoration(hintText: "#", labelText: "Table Number"),
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.number,
                  )
                ]
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('DELETE'),
                onPressed: () {
                  tables.removeAt(index);
                  setState((){});
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('UPDATE'),
                onPressed: () {
                  tables[index] = int.parse(_tFCTableNum.text);
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
      _tFCNumGuests.clear();
      _tFCTableNum.clear();
    });
  }

  @override
  Widget build (BuildContext ctxt) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Tables"),
      ),
      body: new GridView.builder(
          itemCount: tables.length,
          gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
          itemBuilder: (BuildContext context, int index) {
            return new GestureDetector(
              child: new Card(
                elevation: 5.0,
                child: new Container(
                  alignment: Alignment.center,
                  child: new Text('Table ${tables[index]}'),
                ),
              ),
              onTap: () {
                _tFCTableNum.text = '${tables[index]}';
                _displayEditDialog(context, index);
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _displayAddDialog(context),
      ),
    );
  }

}

//