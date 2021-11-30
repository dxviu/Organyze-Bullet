import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:organyzebullet_app/widgets/text-field-input.dart';
//import 'package:get/get.dart';
import 'package:organyzebullet_app/database/realtime_database_function.dart';


//import '../controllers/note_controller.dart';

class AddNewNotebook extends StatelessWidget {
  //final NoteController controller = Get.find();
  //final _database = FirebaseDatabase.instance.reference();
  realtime r = new realtime();
  final ID =  "-test";//FirebaseAuth.instance.currentUser?.uid ?? "test";

  @override
  Widget build(BuildContext context) {

    final notebookName = TextEditingController();

    notebookName.addListener(() => {});

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add New Notebook",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
          ),
          child: Column(
            children: [
              TextField(
                controller: notebookName,
                //controller: controller.titleController,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    letterSpacing: 1,
                  ),
                  border: InputBorder.none,
                ),

              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //onPressed: () {controller.addNoteToDatabase();},
        onPressed: () { r.createNotebook(ID, notebookName.text);
        Navigator.pushNamed(context, 'viewNotebooks');
        },
        child: Icon(
          Icons.check,
        ),
      ),
    );
  }
}
