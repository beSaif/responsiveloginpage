import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/pages/homePage.dart';
import '../size_config.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({Key key}) : super(key: key);
  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  String phoneNumber;
  String verficationCode;
  final _formKeyPhone = GlobalKey<FormState>();
  bool saveAttempted = false;
  String otpcode;

  TextEditingController
      codeController; // codecontroller:smscode fix. not printing and all
  TextEditingController phoneController;
  String verificationId;

  // ignore: missing_return
  Future<bool> loginUser(phoneNumber, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();
          UserCredential result = await _auth.signInWithCredential(credential);
          User user = result.user;
          if (user != null) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => HomePage(user: user)));
          }
        },
        verificationFailed: (FirebaseAuthException exception) {
          // ignore: unnecessary_brace_in_string_interps
          print('Failed + ${exception}');
        },
        codeSent: (verificationId, [int forceResendingToker]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text('Enter the code'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          otpcode = value;
                          print(otpcode);
                        },
                        keyboardType: TextInputType.number,
                        controller: codeController,
                      ),
                    ],
                  ),
                  actions: [
                    FlatButton(
                        onPressed: () async {
                          AuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: otpcode);
                          UserCredential result =
                              await _auth.signInWithCredential(credential);
                          User user = result.user;
                          if (user != null) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(user: user)));
                          } else {
                            print('error');
                          }
                        },
                        child: Text('Confirm'))
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: (verificationId) {});
  }

  _onClear() {
    setState(() {
      phoneController = TextEditingController(text: '');
      phoneNumber = '';
    });
  }

  @override
  void initState() {
    phoneController = TextEditingController(text: '+91');
    super.initState();
  }

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
                        child: Form(
                          key: _formKeyPhone,
                          child: Container(
                            alignment: Alignment.center,
                            child: TextFormField(
                              onSaved: (value) => phoneNumber = value,
                              autovalidate: saveAttempted,
                              validator: (value) {
                                if (value.length != 13) {
                                  return 'Please enter a valid phone number.';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              controller: phoneController,
                              decoration: InputDecoration(
                                  hintText: '+91...',
                                  hoverColor: Colors.white,
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  suffix: IconButton(
                                      icon: Icon(Icons.cancel),
                                      onPressed: _onClear)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            0, SizeConfig.blockSizeVertical * 0, 0, 0),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKeyPhone.currentState.validate()) {
                              _formKeyPhone.currentState.save();
                            }
                            setState(() {
                              saveAttempted = true;
                              phoneNumber = phoneController.text.trim();
                              print(phoneNumber);
                              loginUser(phoneNumber, context);
                            });
                          },
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
