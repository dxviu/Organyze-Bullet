


import 'dart:convert';

import 'package:flutter/cupertino.dart';

class userModel{

  final String username;
  final String email;
  final String ID;



  userModel({required this.username, required this.email,required this.ID});



  factory userModel.fromtRTDB(Map<String,dynamic> data){
    return userModel(
        username: data['Username'] as String,
        email: data['email'] as String,
        ID: data['id'] as String);
  }
  
  String getUsername(){
    return this.username as String;
  }

  String getEmail(){
    return this.email;
  }

}


class notebookModel{
  final String notebookName;
  final String notebookID;

  notebookModel({required this.notebookName,required this.notebookID});

  factory notebookModel.fromRTDB(Map<String,dynamic> data){
    return notebookModel(
        notebookName: data['notebookname'] as String,
        notebookID: data['notebookID'] as String
    );
  }

  String getNotebookName(){
    return this.notebookName;
  }

}

class entryModel{
  final String entryName;
  final String date;
  final String UID;
  final String description;
  final String entryType;


  entryModel({required this.description, required this.date, required this.UID, required this.entryType, required this.entryName});

  factory entryModel.fromRTDB(Map<String,dynamic> data){
    return entryModel(
        description: data['description'] as String,// ?? 'Enter a description',
        UID: data['UID'] as String,// ?? '-0',
        entryName: data['name'] as String,// ?? 'Enter a Entry name',
        entryType: data['type'] as String,// ?? 'Enter a Entry type',
        date: data['timestamp'] as String// ?? "00/00/00"
    );
  }
}