import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:organyzebullet_app/database/dataModels.dart';
import 'package:organyzebullet_app/database/realtime_database_function.dart';

class notebookListPublisher {
  final _database = FirebaseDatabase.instance.reference();

  Stream<List<notebookModel>> getNotebookList(String path){
    final orderStream = _database.child(path).onValue;
    final streamToPublish = orderStream.map((event) {
      final orderMap = Map<String,dynamic>.from(event.snapshot.value);
      final orderList = orderMap.entries.map((element)  {
        return notebookModel.fromRTDB(Map<String,dynamic>.from(element.value));
      }).toList();
      return orderList;
    });
    return streamToPublish;
  }
}
class entryStreamPublisher{
  final _database = FirebaseDatabase.instance.reference();

  Stream<List<entryModel>> getEntryStream(String path){
    final orderStream = _database.child(path).onValue;
    final streamToPublish = orderStream.map((event){
      final orderMap = Map<String,dynamic>.from(event.snapshot.value);
      final orderList = orderMap.entries.map((element) {
        return entryModel.fromRTDB(Map<String,dynamic>.from(element.value));
      }).toList();
      return orderList;
    });
    return streamToPublish;
  }
}