import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:organyzebullet_app/database/dataModels.dart';
import 'package:organyzebullet_app/database/realtime_database_function.dart';

class notebookListPublisher {
  final _database = FirebaseDatabase.instance.reference();

  Stream<List<notebookModel>> getNotebookList(String ID){
    final orderStream = _database.child('Users/-test/Notebooks/').onValue;
    final streamToPublish = orderStream.map((event) {
      final orderMap = Map<String,dynamic>.from(event.snapshot.value);
      final notebookList = orderMap.entries.map((element)  {
        return notebookModel.fromRTDB(Map<String,dynamic>.from(element.value));
      }).toList();
      return notebookList;
    });
    return streamToPublish;
  }
}