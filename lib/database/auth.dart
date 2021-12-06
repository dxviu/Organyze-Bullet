import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';


class auth {
  final database = FirebaseDatabase.instance.reference(); //not sure if i need this here -\._./-

  void anon() async {
    FirebaseAuth.instance.signInAnonymously();
  }
    void main() {
    User? user = FirebaseAuth.instance.currentUser;
    String i = '';
    String j = '';

    group('Six Methods Unit Testing', () {
      test('Load a list', () async {
        expect(verifyEmailtoLogin(), 0);
        expect(createUser(i, j), 'The password provided is too weak.');
        expect(signInEmail(i, j), 'No user found');
        expect(sendverificationEmailWOChecking(), 'sent');
        expect(verifyEmail(), 'sent');
        expect(getCurrentUserID(), 'no uid');
      });
    });
  }

  String createAuthUser(String emailInput, String passwordInput) {
    try {
    FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailInput,
          password: passwordInput
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return ('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return ('The account already exists for that email.');
      }
    } catch (e) {
      //print(e);
      return ("other error");
    }
    return ('Account-Created');
  }




  String signInEmail(String emailInput, String passwordInput) {
    String err = '';
    try {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: emailInput,
          password: passwordInput
      );
      err = "Account-Created";
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print('No user found for that email.');
        err = ('No user found');
      } else if (e.code == "wrong-password") {
        print('Wrong password provided for that user.');
        err =  ("wrong password");
      }
    }catch (e){
      //print(e);
      print("testing error catch");
    }
    print("signed-in");
    print(err);
    return "signed-in";
  }


  Future<String> signInEmailf(String emailInput, String passwordInput) async {
    String err = '';
    try {
      UserCredential? User = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: emailInput,
          password: passwordInput
      );
      err = "Account-Created";
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print('No user found for that email.');
        err = ('No user found');
      } else if (e.code == "wrong-password") {
        print('Wrong password provided for that user.');
        err =  ("wrong password");
      }
    }catch (e){
      //print(e);
      print("testing error catch");
    }
    print("signed in");
    print(err);
    return "signed-in";
  }


  Future <void> verifyEmail() async {
    User? user = await FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      print("sent");
    }
    else if (user == null){
      print("null user while verifiying");
    }
  }

  Future<void> signInWithGoogle() async {
    //Logs in user.. can be used for creating a user just needs a user name
    // Trigger the Google Authentication flow.
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request.
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    // Create a new credential.
    final AuthCredential googleCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Sign in to Firebase with the Google [UserCredential].
    final UserCredential googleUserCredential =
    await FirebaseAuth.instance.signInWithCredential(googleCredential);
  }


  Future <void> sendverificationEmailWOChecking() async {
    User? user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
      print("sent");
    }
  }

  int verifyEmailtoLogin() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      return 0;

    }
    else {
      print("Email is not verified");
      return 1;
    }
  }//this function is only meant to be used for the login scree, might be better in a abtract class but this is easier to do

  String getCurrentUserID(){
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.uid != null){
      return user.uid as String;
    }
    else return "no uid";
  }

  String getCurrentEmail(){
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.uid != null){
      return user.email as String;
    }
    else return "null-user";
  }

  void signoutEmail() {
     FirebaseAuth.instance.signOut();
  } // untested

  bool checkNullUser(){
    if(FirebaseAuth.instance.currentUser != null){return false;}else{return true;}
  }


}

