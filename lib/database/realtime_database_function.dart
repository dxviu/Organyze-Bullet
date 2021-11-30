import 'dart:async';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../main.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class realtime {
  final database = FirebaseDatabase.instance.reference();
  //FirebaseAuth auth = FirebaseAuth.instance;

  void createUser(String ID, String username, String email) {
    final account = database.child('Users/');
    account.update({
          ID: {
            'Username': username, 'id': ID, 'Email': email,'Notebooks':{
              "placeHolder"
            }
          }
        }
    ).then((_) => print("Has been added"))
    .catchError((error) => print("cannot create user, try again"));
}


}