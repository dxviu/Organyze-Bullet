import 'dart:ui';
import 'package:organyzebullet_app/database/dataModel.dart';
import 'package:organyzebullet_app/database/auth.dart';
import 'package:organyzebullet_app/database/message_dao.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:organyzebullet_app/database/realtime_database_function.dart';
import 'package:organyzebullet_app/pallete.dart';
import 'package:organyzebullet_app/widgets/widgets.dart';
import 'package:organyzebullet_app/widgets/text-field-input.dart';
import 'package:firebase_auth/firebase_auth.dart';


class CreateNewAccount extends StatelessWidget {


    authCreateAcc auth = new authCreateAcc();
    realtime r = new realtime();


  @override
  Widget build(BuildContext context) {
    int idNumo = 1;
    String createErrString;
    int createErrCode = 0; // zero is no error at all, 1 is the password is too low, 2 is the email is already registers
    //final account = database.child('UID/');
    final usero = TextEditingController();
    final emailo = TextEditingController();
    final passwordo = TextEditingController();
    final passwordchecko = TextEditingController();


    usero.addListener(() => print('first text field: ${usero.text}'));
    emailo.addListener(() => print('second text field: ${emailo.text}'));
    passwordo.addListener(() => print('password text field: ${passwordo.text}'));
    passwordchecko.addListener(() => print('check text field: ${passwordchecko.text}'));

    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        BackgroundImage(image: 'assets/images/reg.png'),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.width * 0.1,
                ),
                Stack(
                  children: [
                    Center(
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: CircleAvatar(
                            radius: size.width * 0.14,
                            backgroundColor: Colors.grey[400]!.withOpacity(
                              0.4,
                            ),
                            child: Icon(
                              FontAwesomeIcons.user,
                              color: kWhite,
                              size: size.width * 0.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: size.height * 0.08,
                      left: size.width * 0.56,
                      child: Container(
                        height: size.width * 0.1,
                        width: size.width * 0.1,
                        decoration: BoxDecoration(
                          color: kBlue,
                          shape: BoxShape.circle,
                          border: Border.all(color: kWhite, width: 2),
                        ),
                        child: Icon(
                          FontAwesomeIcons.arrowUp,
                          color: kWhite,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: size.width * 0.1,
                ),
                Column(
                  children: [
                    TextInputField(
                      icon: FontAwesomeIcons.user,
                      hint: 'User',
                      inputType: TextInputType.name,
                      inputAction: TextInputAction.next,
                      myController: usero,

                    ),
                    TextInputField(
                      icon: FontAwesomeIcons.envelope,
                      hint: 'Email',
                      inputType: TextInputType.emailAddress,
                      inputAction: TextInputAction.next,
                      myController: emailo,
                    ),
                    PasswordInput(
                      icon: FontAwesomeIcons.lock,
                      hint: 'Password',
                      inputAction: TextInputAction.next,
                      myController: passwordo,
                    ),
                    PasswordInput(
                      icon: FontAwesomeIcons.lock,
                      hint: 'Confirm Password',
                      inputAction: TextInputAction.done,
                      myController: passwordchecko,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                  ElevatedButton(
                    onPressed: () => {
                      idNumo =0,
                      createErrString = createUserWError(usero.text, emailo.text, passwordo.text, passwordchecko.text)
                    },
                    style: ElevatedButton.styleFrom(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(16.0),
                      ),
                    ),
                    child: Text(
                        "Create Account"
                    ),
                  ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: kBodyText,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/');
                          },
                          child: Text(
                            'Login',
                            style: kBodyText.copyWith(
                                color: kBlue, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
       // FutureBuilder()
      ],

    );

  }

  //uses auth
  String createUserWError(String User, String emailInput,String passwordInput,String confirmedPassword) {
    String createErrString = "";
    String ?_id = "";
    if (passwordInput == confirmedPassword) {
      createErrString = auth.createUser(emailInput, passwordInput);
      auth.verifyEmail();
      if (FirebaseAuth.instance.currentUser?.uid != null){_id = FirebaseAuth.instance.currentUser!.uid;}
      else{return "uid is null";}
      _sendMessage(User, _id, emailInput);
    }
    else{
      createErrString = "Passwords are not the same";
    }
    return createErrString;
  }

  void _sendMessage(String nameWrite,String idNum, String emailWrite) {
    if (_canSendMessage()) {
      r.createUser(idNum, nameWrite, emailWrite);
      print("sent message");
    }
  }

  bool _canSendMessage() => true;
}

class authCreateAcc extends auth{}


