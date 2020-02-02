import 'package:flutter/material.dart';
import 'package:flutter_app/authentication/register.dart';
import 'package:flutter_app/log_ins/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SignIn(),
    );
  }
}