import 'package:flutter/material.dart';
import 'package:loginpage/size_config.dart';
import 'forms/signupForm.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(
                      SizeConfig.blockSizeHorizontal * 7,
                      SizeConfig.blockSizeVertical * 10,
                      0,
                      0),
                  child: Text(
                    'create',
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 15.3,
                        fontWeight: FontWeight.w100),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                      SizeConfig.blockSizeHorizontal * 7,
                      SizeConfig.blockSizeVertical * 18,
                      0,
                      0),
                  child: Text(
                    'Account',
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 17,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                      SizeConfig.blockSizeHorizontal * 71,
                      SizeConfig.blockSizeVertical * 16,
                      0,
                      0),
                  child: Text(
                    '.',
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
          SignUpForm(),
        ],
      ),
    );
  }
}
