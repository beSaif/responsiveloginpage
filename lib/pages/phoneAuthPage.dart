import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/pages/forms/loginForm.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../size_config.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({Key key}) : super(key: key);
  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: Builder(builder: (context) {
        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical * 1,
                  left: SizeConfig.blockSizeHorizontal * 1),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      SizeConfig.blockSizeHorizontal * 7,
                      SizeConfig.blockSizeVertical * 0,
                      SizeConfig.blockSizeHorizontal * 7,
                      0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                0, SizeConfig.blockSizeVertical * 0, 0, 0),
                            child: Text(
                              'enter your',
                              style: TextStyle(
                                  fontSize: SizeConfig.blockSizeHorizontal * 8,
                                  fontWeight: FontWeight.w100),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(
                                    0, SizeConfig.blockSizeVertical * 3, 0, 0),
                                child: Text(
                                  'Phone Number',
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 8.5,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(
                                    SizeConfig.blockSizeHorizontal * 0,
                                    SizeConfig.blockSizeVertical * 0,
                                    0,
                                    0),
                                child: Text(
                                  '.',
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(
                                  0, SizeConfig.blockSizeVertical * 10, 0, 0),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: 'We will send you an ',
                                      style: TextStyle(color: Colors.green)),
                                  TextSpan(
                                      text: 'One Time Password ',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: 'on this mobile number',
                                      style: TextStyle(color: Colors.green)),
                                ]),
                              )),
                        ],
                      ),
                      Container(
                        height: 40,
                        margin:
                            EdgeInsets.all(SizeConfig.blockSizeHorizontal * 4),
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: CupertinoTextField(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          controller: phoneController,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          keyboardType: TextInputType.phone,
                          maxLines: 1,
                          placeholder: '+33...',
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            0, SizeConfig.blockSizeVertical * 0, 0, 0),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: RaisedButton(
                          onPressed: () {},
                          color: Colors.green,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14))),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Next',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    color: Colors.green,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        );
      }),
    );
  }
}
