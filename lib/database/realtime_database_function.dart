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
            'Username': username, 'id': ID, 'Email': email, 'Password': password,'Notebooks':{
              "placeHolder"
            }
          }
        }
    ).then((_) => print("Has been added"))
    .catchError((error) => print("cannot create user, try again"));
}

  void createNotebook(String notebookName) {
    final account = database.child('Notebooks/6/');
    account.update({
        notebookName : {
          }
        }
    ).then((_) => print("Notebook has been added"))
        .catchError((error) => print("cannot create user, try again"));
  }



}