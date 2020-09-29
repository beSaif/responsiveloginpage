import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/size_config.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email, password, passwordConfirm;
  final formKey = GlobalKey<FormState>();
  bool saveAttempted = false;

  void _createUser({String email, String password}) {
    _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((authResult) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Container(
          color: Colors.yellow,
          child: Text('Welcome ${authResult.user.email}'),
        );
      }));
      print('yay! ${authResult.user.email}');
    }).catchError((err) {
      print(err.message);
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Input Error'),
              content: Text(err.message),
              actions: [
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text('Close'))
              ],
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 0),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.12),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              autovalidate: saveAttempted,
              onChanged: (textValue) {
                setState(() {
                  email = textValue;
                });
              },
              validator: (emailValue) {
                if (emailValue.isEmpty) {
                  return 'This field is mandatory.';
                }

                String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                    "\\@" +
                    "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                    "(" +
                    "\\." +
                    "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                    ")+";
                RegExp regExp = new RegExp(p);

                if (regExp.hasMatch(emailValue)) {
                  // So, the email is valid
                  return null;
                }

                return 'This is not a valid email';
              },
              decoration: InputDecoration(
                  labelText: 'EMAIL',
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green))),
            ),
            TextFormField(
              obscureText: true,
              autovalidate: saveAttempted,
              onChanged: (textValue) {
                setState(() {
                  password = textValue;
                });
              },
              validator: (passwordValue) {
                if (passwordValue.isEmpty) {
                  return 'This field is mandatory.';
                }
                if (passwordValue.length < 8) {
                  return 'Password must be atleast 8 characters';
                }
                return null;
              },
              decoration: InputDecoration(
                  labelText: 'PASSWORD',
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green))),
            ),
            TextFormField(
              obscureText: true,
              autovalidate: saveAttempted,
              onChanged: (textValue) {
                setState(() {
                  passwordConfirm = textValue;
                });
              },
              validator: (pwConfValue) {
                if (pwConfValue != password) {
                  return 'Passwords must match.';
                }
                return null;
              },
              decoration: InputDecoration(
                  labelText: 'CONFIRM PASSWORD',
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green))),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 4.5,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  saveAttempted = true;
                });
                if (formKey.currentState.validate()) {
                  formKey.currentState.save();
                  _createUser(email: email, password: password);
                }
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 8.5,
                child: Material(
                  borderRadius: BorderRadius.circular(
                      SizeConfig.blockSizeHorizontal * 60),
                  shadowColor: Colors.greenAccent,
                  elevation: 7,
                  color: Colors.green,
                  child: Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 5.5,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeHorizontal * 4),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: SizeConfig.blockSizeHorizontal * 16.5,
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: SizeConfig.blockSizeHorizontal * 0.6),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(
                          SizeConfig.blockSizeHorizontal * 60)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'GO BACK',
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 5,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
