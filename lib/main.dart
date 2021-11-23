import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organyzebullet_app/database/dataModels.dart';
import 'package:organyzebullet_app/database/realtime_database_function.dart';
import 'package:organyzebullet_app/screens/view_notebooks.dart';
import 'screens/screens.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:organyzebullet_app/database/message_dao.dart';
import 'package:organyzebullet_app/database/dataModels.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();                         //this is IMPORTANT to not have a null error message
  await Firebase.initializeApp();
  //final _database = FirebaseDatabase.instance.reference();
  //_database.child('Users/-test/Notebooks/').orderByKey().onValue.listen((event) {
  //  print(event.snapshot.value);
  //});
  //realtime r = new realtime();
  //r.getNotebook('-test');
  //r.createUser('-test', "testU", "testE");
  //r.createNotebook("-test","testNotebook");
  //print (_database.child('User/$ID/Notebooks').orderByKey().onValue)
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Organyze Bullet',
      theme: ThemeData(
        textTheme:
            GoogleFonts.josefinSansTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        'ForgotPassword': (context) => ForgotPassword(),
        'CreateNewAccount': (context) => CreateNewAccount(),
        'AddNewEntry': (context) => AddNewEntry(),
        'viewEntries': (context) => viewEntries(),
        'viewNotebooks':(context) => viewNotebooks(),
        //'HomeScreen': (context) => HomeScreen(),
        //test
      },
    );



  }




}
