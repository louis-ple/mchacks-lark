// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/authentication/authenticate.dart';
import 'package:flutter_app/authentication/wrapper.dart';
import 'package:flutter_app/log_ins/auth.dart';
import 'package:flutter_app/log_ins/sign_in.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/models/user.dart';

import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctxt) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
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
  final int tableNumber;
  final int numGuests;
  final DocumentReference reference;

  _Table.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['tableNumber'] != null),
        assert(map['numGuests'] != null),
        tableNumber = map['tableNumber'],
        numGuests = map['numGuests'];

  _Table.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Table<$tableNumber:$numGuests guests>";
}

class FirstScreen extends StatelessWidget {

  final AuthService _auth = AuthService();
  @override
  Widget build (BuildContext ctxt) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Robohost"),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async{
                Navigator.push(
                  ctxt,
                    MaterialPageRoute(builder: (context) => SignIn())
                );
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            new Row(
              children: <Widget> [
                new Checkbox(
                    value: false,
                    onChanged: (bool newValue) {
                      Navigator.push(
                        ctxt,
                        new MaterialPageRoute(builder: (ctxt) => new ServerScreen()),
                      );
                    }
                ),
                new Text("Servers")
              ]
            ),
            new Row(
              children: <Widget> [
                new Checkbox(
                    value: false,
                    onChanged: (bool newValue) {
                      Navigator.push(
                        ctxt,
                        new MaterialPageRoute(builder: (ctxt) => new TableScreen()),
                      );
                    }
                ),
                new Text("Tables")
              ]
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

  _displayAddDialog(BuildContext context) async {
    final db = Firestore.instance;
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
                  Map<String, Object> data = {"name" : _textFieldController.text, "tables" : List.castFrom([0, 1, 2])};
                  db.collection("servers").document(_textFieldController.text).setData(data);
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
    final db = Firestore.instance;
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
              new FlatButton(
                child: new Text('DELETE'),
                onPressed: () {
                  db.collection("servers").document(server.reference.documentID).delete();
                  setState((){});
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('UPDATE'),
                onPressed: () {
                  final Map<String, dynamic> data = {"name": _textFieldController.text};
                  db.collection("servers").document(server.reference.documentID).updateData(data);
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
    final db = Firestore.instance;

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
          //trailing: Text(db.collection("servers").document(server.tables).toString()),
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
  final db = Firestore.instance;
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
                  Map<String, Object> data = {"tableNumber" : int.parse(_tFCTableNum.text), "numGuests" : int.parse(_tFCNumGuests.text)};
                  db.collection("tables").document(_tFCTableNum.text).setData(data);
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

  _displayEditDialog(BuildContext context, _Table table) async {
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
                  db.collection("tables").document(table.reference.documentID).delete();
                  setState((){});
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('UPDATE'),
                onPressed: () {
                  final Map<String, dynamic> data = {"tableNumber": int.parse(_tFCTableNum.text), "numGuests" : int.parse(_tFCNumGuests.text)};
                  db.collection("tables").document(table.reference.documentID).updateData(data);
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

  Widget _buildBody(BuildContext context) {
    Firestore db = Firestore.instance;
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection('tables').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) return _buildList(context, snapshot.data.documents);

        return LinearProgressIndicator();
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return GridView(
        gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final table = _Table.fromSnapshot(data);
    final db = Firestore.instance;

    return Padding(
      key: ValueKey("Table ${table.tableNumber}"),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text("Table ${table.tableNumber}"),
          //trailing: Text(db.collection("servers").document(server.tables).toString()),
          onTap: () {
            _tFCTableNum.text = "${table.tableNumber}";
            _tFCNumGuests.text = "${table.numGuests}";
            _displayEditDialog(context, table);
          },
        ),
      ),
    );
  }

  @override
  Widget build (BuildContext ctxt) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Tables"),
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _displayAddDialog(context),
      ),
    );
  }

}

//