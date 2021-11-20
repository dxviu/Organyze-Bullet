import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/screens.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();                         //this is IMPORTANT to not have a null error message
  await Firebase.initializeApp();
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
        //'HomeScreen': (context) => HomeScreen(),
        //test
      },
    );



  }




}
