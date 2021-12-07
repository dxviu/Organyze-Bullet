import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:organyzebullet_app/widgets/text-field-input.dart';
//import 'package:get/get.dart';
import 'package:organyzebullet_app/database/realtime_database_function.dart';


//import '../controllers/note_controller.dart';

class updateEntry extends StatelessWidget {
  //final NoteController controller = Get.find();
  final _database = FirebaseDatabase.instance.reference();
  realtime r = new realtime();
  final ID = FirebaseAuth.instance.currentUser?.uid ?? "test";

  @override
  Widget build(BuildContext context) {

    final newPath = ModalRoute.of(context)!.settings.arguments as String;


    final title = TextEditingController();
    final type = TextEditingController();
    final date = TextEditingController();
    final desc = TextEditingController();


    title.addListener(() => {});
    type.addListener(() => {});
    date.addListener(() => {});
    desc.addListener(() =>{});


    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text(
          "Add New Note",
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
                controller: title,
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
              TextField(
                style: TextStyle(
                  fontSize: 22,
                ),
                //controller: controller.contentController,
                controller: type,
                decoration: InputDecoration(
                  hintText: "Type",
                  hintStyle: TextStyle(
                    fontSize: 22,
                  ),
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
              /*TextField(
                style: TextStyle(
                  fontSize: 22,
                ),
                //controller: controller.contentController,
                controller: date,
                decoration: InputDecoration(
                  hintText: "Date",
                  hintStyle: TextStyle(
                    fontSize: 22,
                  ),
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),*/
              /*TextField(
                style: TextStyle(
                  fontSize: 22,
                ),
                //controller: controller.contentController,
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(
                    fontSize: 22,
                  ),
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),*/
              TextField(
                style: TextStyle(
                  fontSize: 22,
                ),
                //controller: controller.contentController,
                controller: desc,
                decoration: InputDecoration(
                  hintText: "Description:",
                  hintStyle: TextStyle(
                    fontSize: 22,
                  ),
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //onPressed: () {controller.addNoteToDatabase();},
        onPressed: () { r.createEntryWithPath(ID, newPath, title.text , type.text,  desc.text); },
        child: Icon(
          Icons.check,
        ),
      ),
    );
  }
}
