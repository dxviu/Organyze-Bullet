import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';
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
        'Username': username, 'id': ID, 'Email': email
      }
    }
    ).then((_) => print("Has been added"))
        .catchError((error) => print("cannot create user, try again"));
  }


  void createNotebook(String ID, String notebookName) {
    final String _path = 'Users/$ID/Notebooks/';
    final account = _database.child(_path);
    account.update({notebookName: {
      "notebookname":notebookName,
      "notebookID" : 2
    }
    }
    ).then((_) => print("Has been added"))
        .catchError((error) => print("cannot create notebook, try again"));
  }

  void createEntry(String ID,String notebookName,String name,String type,String timeStamp,String description){
    final String _path = 'Users/$ID/Notebooks/$notebookName/entries/';
    final account = _database.child(_path);
    final String entryID = getRandomString(10);
    account.update({entryID: {
      "name" : name,
      "type" : type,
      "UID" : entryID,
      "timestamp" : timeStamp,
      "description" : description
    }
    }
    ).then((_) => print("entry has been added"))
        .catchError((error) => print("cannot create entry, try again"));
  }

  String getRandomString(int length) {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return (
    String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))))
    );
  }


}




class pathHandler{
   String path;

  pathHandler({required this.path});

  void setPathForNotebooks(String ID){
    this.path = 'Users/$ID/Notebooks/';
  }

  String setPathForEntries(String ID,String notebookName){
    return('Users/$ID/Notebooks/$notebookName/Entries/');
  }

}
