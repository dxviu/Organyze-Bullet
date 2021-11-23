import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:organyzebullet_app/main.dart';
import 'package:organyzebullet_app/database/realtime_database_function.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:organyzebullet_app/database/Publishers.dart';
import '../pallete.dart';
import 'package:organyzebullet_app/database/dataModels.dart';

class viewEntries extends StatelessWidget{
  // final controller = Get.put(NoteController());
  final _database = FirebaseDatabase.instance.reference();
  final String ID = "-test";
  @override
  Widget build(BuildContext context) {
    final notebookName = ModalRoute.of(context)!.settings.arguments as String;
    final String path = 'Users/$ID/Notebooks/$notebookName/entries/';
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text(
          "Notebooks",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search), onPressed: () {},
            //onPressed: () {showSearch(context: context, delegate: SearchBar());},
          ),
          SizedBox(
            height: 25,
          )
        ],
      ),
      body: StreamBuilder(
          stream: entryStreamPublisher().getEntryStream(path),
          builder: (context, snapshot) {
            final tilesList = <ListTile>[];
            print(path);
            if (snapshot.hasData){
              final myEntrys = snapshot.data as List<entryModel>;
              tilesList.addAll(
                myEntrys.map((nextEntry){
                  return ListTile(
                      leading: Text(nextEntry.date), //or icon
                      title: Text(nextEntry.entryName),
                      subtitle: Text(nextEntry.description));
                }),
              );
            } else {
              tilesList.add(
                ListTile(
                  leading: Icon(Icons.list),
                  title: Text("No Notebook Created"))
              );
            }
            //ListView.builder(
            //   itemCount: 5,
            //  itemBuilder: (BuildContext context, int index) {
            return ListView(
              children: tilesList,
            );
            // }
            //);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Get.to(AddNewNotePage());
          Navigator.pushNamed(context, 'AddNewEntry');
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}


