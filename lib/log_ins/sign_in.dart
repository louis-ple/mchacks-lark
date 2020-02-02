import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/authentication/authenticate.dart';
import 'package:flutter_app/authentication/register.dart';
import 'package:flutter_app/log_ins/auth.dart';
import 'package:flutter_app/main.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          title: Text('Sign in'),
        ),
        body: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment(0.05, -0.8),
                child: RaisedButton(
                    color: Colors.white,
                    child: Text('Sign in with email'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    }
                ),
              ),
              Align(
                alignment: Alignment(0.05, -0.6),
                child: RaisedButton(
                    color: Colors.white,
                    child: Text('Register'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      );
                    }
                ),
              ),//    new MaterialButton(),
            ]
        )
    );
  }
}
class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

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
        title: Text('Sign In page'),
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
                child: Text('Sign in'),
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


