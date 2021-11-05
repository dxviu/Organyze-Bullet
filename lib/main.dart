import 'package:flutter/material.dart';
import 'package:organyzebullet_app/screens/add-entry.dart';
import 'package:organyzebullet_app/screens/eg-entry.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:organyzebullet_app/screens/home-screen.dart';
import 'package:organyzebullet_app/screens/view_entries.dart';
import 'screens/screens.dart';

void main() {
  runApp(MyApp());

}

/*class dbfunc extends realtime {
  @override
  Future<void> createUser(int ID, String username, String email, String password) async {
    final account = database.child('UID/');
    return Future.delayed(
        const Duration(milliseconds:1), () => account.set({'UID': ID,'Username':username,'Email':email,'Password':password}));
  }
}*/

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
   //final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Organyze Bullet',
      theme: ThemeData(
        //textTheme:GoogleFonts.josefinSansTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      /*home: FutureBuilder(
        future: _fbApp,
            builder: (context,snapshot) {
              if(snapshot.hasError) {
                print('You have an error! ${snapshot.error.toString()}');
                return Text('Something went wrong');}
                else if (snapshot.hasData) {
                  return LoginScreen();}
                else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                  }
                },
      ),*/
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        'ForgotPassword': (context) => ForgotPassword(),
        'CreateNewAccount': (context) => CreateNewAccount(),
        'AddNewEntry': (context) => AddNewEntry(),
        'viewEntries': (context) => viewEntries(),
        'exampleEntry' : (context) => egEntry(),
        //'HomeScreen': (context) => HomeScreen(),
      },
    );



  }




}




