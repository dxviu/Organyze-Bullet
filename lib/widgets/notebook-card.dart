import 'package:flutter/material.dart';
import 'package:organyzebullet_app/pallete.dart';

/*class TextInputField extends StatelessWidget {
  const TextInputField({
    Key? key,
    required this.icon,
    required this.hint,
    this.inputType,
    this.inputAction,
    this.myController
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final TextEditingController? myController;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      height: 220,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                  width: 2.0,
                  color: Color.fromRGBO(121, 85, 72, 100),
              ),
            ),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(7),
            child: Stack(children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Stack(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                cryptoIcon(cryptoData[index]),
                                SizedBox(
                                  height: 10,
                                ),
                                cryptoNameSymbol(cryptoData[index]),
                                Spacer(),
                                cryptoChange(cryptoData[index]),
                                SizedBox(width: 10,),
                                changeIcon(cryptoData[index]),
                                SizedBox(width: 20,)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                cryptoAmount(cryptoData[index])
                              ],
                            )
                          ],
                        ))
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}*/