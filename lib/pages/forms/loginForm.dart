import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginpage/pages/phoneAuthPage.dart';
import 'package:loginpage/size_config.dart';

import '../phoneAuthPage.dart';

class LogInForm extends StatefulWidget {
  @override
  _LogInFormState createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email, password;
  final formKey = GlobalKey<FormState>();
  bool saveAttempted = false;
  final snackBar = SnackBar(content: Text('working'));

  void _logIn({String email, String password, BuildContext context}) {
    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((authResult) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Container(
          color: Colors.yellow,
          child: Text('Welcome ${authResult.user.email}'),
        );
      }));
    }).catchError((err) {
      print(err.code);
      if (err.message != 'Given String is empty or null') {
        if (err.code == 'user-not-found') {
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text('No user with $email exist')));
        }
        if (err.code == 'wrong-password') {
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Incorrect password. Please try again or reset password.')));
        }
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(err.message)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 18),
        child: Column(
          children: [
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
            SizedBox(
              height: SizeConfig.blockSizeVertical * 0.6,
            ),
            Container(
              alignment: Alignment(1, 0),
              padding: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical * 1.8,
                  left: SizeConfig.blockSizeHorizontal * 7),
              child: InkWell(
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.dotted),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 2,
            ),
            InkWell(
              onTap: () {
                if (formKey.currentState.validate()) {
                  formKey.currentState.save();
                }
                _logIn(email: email, password: password, context: context);
                setState(() {
                  saveAttempted = true;
                });
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 6.5,
                child: Material(
                  borderRadius: BorderRadius.circular(
                      SizeConfig.blockSizeHorizontal * 60),
                  shadowColor: Colors.greenAccent,
                  elevation: 7,
                  color: Colors.green,
                  child: Center(
                    child: Text(
                      'LOGIN',
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
            SizedBox(height: SizeConfig.blockSizeVertical * 2.5),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PhoneAuthPage()));
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 5.2,
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
                        child: ImageIcon(
                            AssetImage('assets/icons8-facebook-f-24.png')),
                      ),
                      Center(
                        child: Text(
                          'Log in with Phone Number',
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 3,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w100),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New to TCC?',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 0.2,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/signup');
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.dotted),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
