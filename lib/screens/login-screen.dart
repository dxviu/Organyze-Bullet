import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:organyzebullet_app/database/auth.dart';
import 'package:organyzebullet_app/pallete.dart';
import 'package:organyzebullet_app/widgets/widgets.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';


class LoginScreen extends StatelessWidget {
  loginAuth auth = new loginAuth();

  @override
  Widget build(BuildContext context) {

    final usero = TextEditingController();
    final emailo = TextEditingController();
    final passwordo = TextEditingController();


    usero.addListener(() => {});
    emailo.addListener(() => {});
    passwordo.addListener(() => {});

    Size size = MediaQuery.of(context).size; // from button

    return Stack(
      children: [
        BackgroundImage(
          image: 'assets/images/login.png',
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Flexible(
                child: Center(
                  child: Text(
                    'Organyze Bullet',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
                    inputAction: TextInputAction.done, inputType: null,
                    myController: passwordo,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, 'ForgotPassword'),
                    child: Text(
                      'Forgot Password',
                      style: kBodyText,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),

                  Container(
                    height: size.height * 0.08,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.brown,
                  ),
                    child: ElevatedButton(
                      onPressed: ()  {if (auth.signInEmail(emailo.text, passwordo.text) == "Account Created") {
                                        if (auth.verifyEmailtoLogin() == 0)
                                          Navigator.pushNamed(context, 'viewEntries');
                                        else{print("not verified");}
                                        }
                                      else{print("Make sure password and email are correct");}
                                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            //side: BorderSide(color: Colors.red)
                            )
                          )
                      ),
                      child: Text(
                        "Login",
                        style:
                          kBodyText.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
              GestureDetector(
                  onTap: () => {
                    Navigator.pushNamed(context, 'viewEntries'),
                    auth.anon()
                  },
                  child: Container(
                    child:Text(
                      'Guest login',
                      style: kBodyText,
                    ),
                    decoration: BoxDecoration(
                     border:
                       Border(bottom: BorderSide(width: 1, color: kWhite))),
                    ),
                  ),
              SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'CreateNewAccount'),
                child: Container(
                  child: Text(
                    'Create New Account',
                    style: kBodyText,
                  ),
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(width: 1, color: kWhite))),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class loginAuth extends auth{


}