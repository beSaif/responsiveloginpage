import 'package:flutter/material.dart';
import 'package:loginpage/size_config.dart';
import 'forms/loginForm.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
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
                    child: Text(
                      'hello',
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 15,
                          fontWeight: FontWeight.w100),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            0, SizeConfig.blockSizeVertical * 7, 0, 0),
                        child: Text(
                          'there',
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            SizeConfig.blockSizeHorizontal * 0,
                            SizeConfig.blockSizeVertical * 5,
                            0,
                            0),
                        child: Text(
                          '.',
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                  LogInForm(),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
