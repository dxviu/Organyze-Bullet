


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
    return this.username;
  }

  String getEmail(){
    return this.email;
  }

}