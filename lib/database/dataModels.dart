


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