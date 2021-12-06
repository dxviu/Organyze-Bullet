
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';




void main() {

    test('return path ending in notebooks', ()  {
      pathHandler p = new pathHandler();

      String ID = "555";
      String notebookName = "test";
      String entryID = "5555";

     expect(p.setPathToEntry(ID,notebookName,entryID),'Users/555/Notebooks/test/Entries/5555/');
   });
}

class pathHandler{
  String path='Users/';

  String setPathForNotebooks(String ID){
    return 'Users/$ID/Notebooks/';
  }

  String setPathForEntries(String ID,String notebookName){
    return('Users/$ID/Notebooks/$notebookName/Entries/');
  }

  String setPathToEntry(String ID,String notebookName,String entryID){
    return'Users/$ID/Notebooks/$notebookName/Entries/$entryID/';
  }

  String getPath(){return this.path;}
}


class userModel{

  final String username;
  final String email;
  final String ID;

  userModel({required this.username, required this.email,required this.ID});


  String getUsername(){
    return this.username as String;
  }

  String getEmail(){
    return this.email;
  }

  String getID(){
    return this.ID;
  }

}

