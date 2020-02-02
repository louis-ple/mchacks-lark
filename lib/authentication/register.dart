import 'package:flutter/material.dart';
import 'package:flutter_app/log_ins/auth.dart';
import 'package:flutter_app/main.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();

  // text field state
  String name = '';
  String email = '';
  String password = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          title: Text('Register Page'),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical:20.0, horizontal: 50.0),
            child: Form(
                child: Column(
                  children: <Widget>[
                    //name
                    SizedBox(height: 20.0),
                    Text('Name'),
                    TextFormField(
                        onChanged: (val){
                          setState(() => name = val);
                        }
                    ),
                    // email
                    SizedBox(height: 20.0),
                    Text('Email'),
                    TextFormField(
                        onChanged: (val){
                          setState(() => email = val);
                        }
                    ),
                    // password
                    SizedBox(height: 20.0),
                    Text('Password'),
                    TextFormField(
                      obscureText: true,
                      onChanged: (val){
                        setState(() => password = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      color: Colors.cyan[400],
                      child: Text('Register'),
                      onPressed: () async{
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FirstScreen())
                        );
                      },
                    )
                  ],
                )
            )
        )
    );
  }
}
