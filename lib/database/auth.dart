import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';


class auth {
  final database = FirebaseDatabase.instance.reference(); //not sure if i need this here -\._./-

  void anon() async {
    FirebaseAuth.instance.signInAnonymously();
  }

  String createUser(String emailInput, String passwordInput) {
    try {
      FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailInput,
          password: passwordInput
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') 
      {
        print('The password provided is too weak.');
        return ('The password provided is too weak.');
      } 
      else if (e.code == 'email-already-in-use') 
      {
        print('The account already exists for that email.');
        return ('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
      return ('Account Created');
    }
    return ('');
  }


  String signInEmail(String emailInput, String passwordInput) {
    String err = "";
    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailInput,
          password: passwordInput
      );
    } on FirebaseAuthException catch (e) 
    {
      if (e.code == 'user-not-found') 
      {
        print('No user found for that email.');
        err = 'No User Found';
      } 
      else if (e.code == 'wrong-password') 
      {
        print('Wrong password provided for that user.');
        err =  "Wrong Password");
      }
    } catch (e) {
      print(e);
      print("signed in");
      err = "Account Created";
    }
    return err;
  }

  Future <void> verifyEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      print("sent");
    }
  }

  int verifyEmailtoLogin() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      print("Email is not verified");
      return 1;
    }
    else {
      return 0;
    }
  }//this function is only meant to be used for the login scree, might be better in a abtract class but this is easier to do

  Future <void> signoutEmail() async {
    await FirebaseAuth.instance.signOut();
  } // untested
}
