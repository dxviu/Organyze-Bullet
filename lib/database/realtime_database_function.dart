import 'dart:async';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../main.dart';
//import 'package:firebase_auth/firebase_auth.dart';

void main() async {

  //await Firebase.initializeApp();
  //realtime r = new realtime();
  print("done");

  //await r.createUser(2, 'bob', 'bob@email.com', 'bobpassword');

}

class realtime {
  final database = FirebaseDatabase.instance.reference();
  //FirebaseAuth auth = FirebaseAuth.instance;

  void createUser(String ID, String username, String email, String password) {
    final account = database.child('Users/');
    account.update({
          ID: {
            'Username': username, 'id': ID, 'Email': email, 'Password': password, 'Notebooks': {
              'Entries': {
                "1": {
                  'name': "testname", 'timestamp': "01/01/01", 'type': "Task"
                }
              }
            }
          }
        }
    ).then((_) => print("Has been added"))
    .catchError((error) => print("cannot create user, try again"));
}



}