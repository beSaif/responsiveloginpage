import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loginpage/pages/forms/loginForm.dart';
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
      body: Builder(builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  SizeConfig.blockSizeHorizontal * 7,
                  SizeConfig.blockSizeVertical * 0,
                  SizeConfig.blockSizeHorizontal * 7,
                  0),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        0, SizeConfig.blockSizeVertical * 0, 0, 0),
                    child: Text(
                      'create',
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 11,
                          fontWeight: FontWeight.w100),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            0, SizeConfig.blockSizeVertical * 0, 0, 0),
                        child: Text(
                          'Account',
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.19),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            SizeConfig.blockSizeHorizontal * 0,
                            SizeConfig.blockSizeVertical * 0,
                            0,
                            0),
                        child: Text(
                          '.',
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFf1c40f)),
                        ),
                      ),
                    ],
                  ),
                  SignUpForm(),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
