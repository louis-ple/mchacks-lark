import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/authentication/authenticate.dart';
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
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.blueGrey[600]),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FirstScreen())
              );
            }),
        title: Text('Sign in'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 110.0),
        child: RaisedButton(
            color: Colors.white,
          child: Text('Sign in anonymously'),
          onPressed:() async{
              dynamic result = await _auth.signInAnonymously();
              if (result == null){
                print('error signing in');
              } else{
                print('signed in');
                print(result.uid);
              }
          }
        ),
      ),
  //    new MaterialButton(),
    );
  }
}
