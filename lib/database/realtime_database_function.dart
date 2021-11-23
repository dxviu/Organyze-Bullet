import 'dart:async';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:organyzebullet_app/database/dataModels.dart';
import '../main.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class realtime {

  final _database = FirebaseDatabase.instance.reference();
  //FirebaseAuth auth = FirebaseAuth.instance;

  void createUser(String ID, String username, String email) {
    final account = _database.child('Users/');
    account.update({
      ID: {
        'Username': username, 'id': ID, 'Email': email, 'Notebooks': "none"//doesnt create 'Notebooks'
      }
    }
    ).then((_) => print("Has been added"))
        .catchError((error) => print("cannot create user, try again"));
  }


  void createNotebook(String ID, String notebookName) {
    final String _path = 'Users/$ID/Notebooks/';
    final account = _database.child(_path);
    account.update({
      notebookName:{"Entries" :"none"}
    }
    ).then((_) => print("Has been added"))
        .catchError((error) => print("cannot create notebook, try again"));
  }

  void getNotebook(String ID){
    _database.child('Users/$ID/Notebooks').onValue.listen((event) {
      final data = new Map<String, dynamic>.from(event.snapshot.value);
      final notebookData = notebookModel.fromRTDB(data);
      print(notebookData.notebookName);
      }
    );


  }

}
