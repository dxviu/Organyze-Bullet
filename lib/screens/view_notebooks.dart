import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:organyzebullet_app/main.dart';
import 'package:organyzebullet_app/database/realtime_database_function.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:organyzebullet_app/database/Publishers.dart';
import 'package:organyzebullet_app/screens/screens.dart';
import '../pallete.dart';



class viewNotebooks extends StatelessWidget {
 // final controller = Get.put(NoteController());
  final _database = FirebaseDatabase.instance.reference();
  final String ID = FirebaseAuth.instance.currentUser?.uid ?? "-test";
  //final String notebookB;


  @override
  Widget build(BuildContext context) {
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
            icon: Icon(Icons.search), onPressed: () {  },
            //onPressed: () {showSearch(context: context, delegate: SearchBar());},
          ),
          SizedBox(height: 25,)
        ],
      ),

      body: StreamBuilder(
        stream: _database.child('Users/$ID/Notebooks/').onValue,
        builder: (context, snapshot) {
          final tilesList = <ListTile>[];
          if(snapshot.hasData) {
            final notebookList = Map<String,dynamic>.from((snapshot.data! as Event).snapshot.value);
            notebookList.forEach((key, value) {
              final nextNotebook = Map<String,dynamic>.from(value);
              final orderTile = ListTile(
                  leading: Icon(Icons.list),
                  onLongPress: () {
                    String notebooknameD = nextNotebook['notebookname'];
                    _database.child('Users/$ID/Notebooks/$notebooknameD/').remove();
                  },
                  onTap: () {
                  String notebooknameB = nextNotebook['notebookname'];
                  print(notebooknameB);
                  Navigator.pushNamed(context, "viewEntries",arguments: notebooknameB);
                  },
                  title: Text(nextNotebook['notebookname']));
            tilesList.add(orderTile);
            }
            );
          }
          else {ListTile(
              leading: Icon(Icons.list),
              title: Text("No Notebook Created")
              );}
          //ListView.builder(
           //   itemCount: 5,
            //  itemBuilder: (BuildContext context, int index) {
          return
            ListView(
              children: tilesList,
             );
             // }
          //);
        }
      ),
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
