import 'package:flutter/material.dart';
import 'package:flutter_app/authentication/authenticate.dart';
import 'package:flutter_app/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // accessing th user data from the provider
    final user = Provider.of<User>(context);


    //return either FirstScreen or Authenticate widget
    if (user == null){
      return Authenticate();
    } else{
      return FirstScreen();
    }
  }
}
