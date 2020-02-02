import 'package:flutter/material.dart';
import 'package:flutter_app/log_ins/auth.dart';
import 'package:flutter_app/main.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String name = '';
  String email = '';
  String password = '';
  String error = '';


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
              key: _formKey,
                child: Column(
                  children: <Widget>[
                    //name
                    SizedBox(height: 20.0),
                    Text('Name'),
                    TextFormField(
                        validator:(val) =>  val.isEmpty ? 'Enter your name' : null,
                        onChanged: (val){
                          setState(() => name = val);
                        }
                    ),
                    // email
                    SizedBox(height: 20.0),
                    Text('Email'),
                    TextFormField(
                      validator:(val) =>  val.isEmpty ? 'Enter your email' : null,
                      onChanged: (val){
                          setState(() => email = val);
                        }
                    ),
                    // password
                    SizedBox(height: 20.0),
                    Text('Password'),
                    TextFormField(
                      obscureText: true,
                      validator:(val) =>  val.length < 6 ? 'Enter a password with more than 6 characters' : null,
                      onChanged: (val){
                        setState(() => password = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      color: Colors.cyan[400],
                      child: Text('Register'),
                      onPressed: () async{
                        if(_formKey.currentState.validate()) {
                          dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                          if (result == null){
                            setState(() => error = 'Please enter a valid email');
                            }
                          }
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FirstScreen())
                        );
                        }
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ],
                )
            )
        )
    );
  }
}
