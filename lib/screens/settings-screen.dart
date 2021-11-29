import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:organyzebullet_app/database/auth.dart';
import 'package:organyzebullet_app/widgets/text-field-input.dart';
//import 'package:get/get.dart';
import 'package:organyzebullet_app/database/realtime_database_function.dart';


//import '../controllers/note_controller.dart';

class Settings extends StatelessWidget {
  //final NoteController controller = Get.find();
  final _database = FirebaseDatabase.instance.reference();
  realtime r = new realtime();
  final ID = "-test";//FirebaseAuth.instance.currentUser?.uid ?? "test";
  auth a = new auth();
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text(
          "Settings",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              a.signoutEmail();
              Navigator.pushNamed(context, '/');
              },
            child: Text("Signout")
            ),
        ],
      )
      );
  }
}
