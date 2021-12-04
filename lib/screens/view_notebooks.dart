import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:organyzebullet_app/database/dataModels.dart';
import 'package:organyzebullet_app/main.dart';
import 'package:organyzebullet_app/database/realtime_database_function.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:organyzebullet_app/database/Publishers.dart';
import 'package:organyzebullet_app/screens/screens.dart';
import '../pallete.dart';



class viewNotebooks extends StatelessWidget {
 // final controller = Get.put(NoteController());
  final _database = FirebaseDatabase.instance.reference();
  final ID = FirebaseAuth.instance.currentUser!.uid;


  @override
  Widget build(BuildContext context) {



    if(FirebaseAuth.instance.currentUser?.uid != null){
      print ("User is:");
      print(FirebaseAuth.instance.currentUser!.uid);
    }
    //final ID = ModalRoute.of(context)!.settings.arguments as String;
    String path = 'Users/$ID/Notebooks/';
    print(path);
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
            icon: Icon(Icons.settings), onPressed: () => Navigator.pushNamed(context, 'settings-screen'),
            //onPressed: () {showSearch(context: context, delegate: SearchBar());},
          ),
          SizedBox(height: 25,)
        ],
      ),
      body: StreamBuilder(
          stream: _database.child('Users/$ID/Notebooks/').onValue,
          builder: (context, snapshot) {
            final tilesList = <ListTile>[];
            print(00);
            if(snapshot.hasData){
              final notebookList = Map<String,dynamic>.from((snapshot.data! as Event).snapshot.value);
              print(11);
              notebookList.forEach((key, value) {
                print(22);
                final nextNotebook = Map<String,dynamic>.from(value);
                print(33);
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
            else {
              final tilesList = <ListTile>[];
              tilesList.add(ListTile(
                  leading: Icon(Icons.list),
                  title: Text("No Notebook Created")
              ));}
            //ListView.builder(
            //   itemCount: 5,
            //  itemBuilder: (BuildContext context, int index) {
            if (tilesList.isNotEmpty) {
              print(0);
              return
                ListView(
                  children: tilesList,
                );
            }
            else {
              print(1);
              return ListTile(
                  leading: Icon(Icons.list),
                  title: Text("No Notebook Created")
              );
            }
            // }
            //);
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Get.to(AddNewNotePage());
          Navigator.pushNamed(context, 'AddNewNotebook');
          },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
