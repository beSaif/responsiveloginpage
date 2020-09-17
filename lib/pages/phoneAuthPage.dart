import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(
                SizeConfig.blockSizeHorizontal * 2,
                SizeConfig.blockSizeVertical * 20,
                SizeConfig.blockSizeHorizontal * 2,
                0),
            child: Center(
              child: Expanded(
                child: Column(
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
                              'enter your',
                              style: TextStyle(
                                  fontSize: SizeConfig.blockSizeHorizontal * 8,
                                  fontWeight: FontWeight.w100),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                SizeConfig.blockSizeHorizontal * 7,
                                SizeConfig.blockSizeVertical * 14,
                                0,
                                0),
                            child: Text(
                              'Phone Number',
                              style: TextStyle(
                                  fontSize: SizeConfig.blockSizeHorizontal * 11,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                SizeConfig.blockSizeHorizontal * 80.5,
                                SizeConfig.blockSizeVertical * 10.8,
                                0,
                                0),
                            child: Text(
                              '.',
                              style: TextStyle(
                                  fontSize: SizeConfig.blockSizeHorizontal * 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 1.8,
                    ),
                    Container(
                        constraints: const BoxConstraints(maxWidth: 500),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
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
                    Container(
                      height: 40,
                      constraints: const BoxConstraints(maxWidth: 500),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: CupertinoTextField(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4))),
                        controller: phoneController,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        keyboardType: TextInputType.phone,
                        maxLines: 1,
                        placeholder: '+33...',
                      ),
                    ),
                    Container(
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
