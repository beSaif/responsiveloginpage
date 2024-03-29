import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/pages/Admin%20Pages/adminPage.dart';
import 'package:loginpage/pages/User%20Pages/homePage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../size_config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({Key key}) : super(key: key);
  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  bool otpFailed = false;
  String phoneNumber;
  String verficationCode;
  final _formKeyPhone = GlobalKey<FormState>();
  bool saveAttempted = false;
  String otpcode;

  // flutter spinkit trigger
  bool loadingState = false;
  // function calling for loading screen to popup
  void openLoadingDialoge() {
    showDialog(
      barrierDismissible: loadingState,
      context: context,
      builder: (BuildContext context) {
        return SpinKitFadingFour(
          color: Color(0xFFf1c40f),
          size: 50.0,
        );
      },
    );
  }

  TextEditingController
      codeController; // codecontroller:smscode fix. not printing and all
  TextEditingController phoneController;
  String verificationId;

  // ignore: missing_return
  Future<bool> loginUser(phoneNumber, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    loadingState = true; // close loaging for otp input
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();
          UserCredential result = await _auth.signInWithCredential(credential);
          User user = result.user;
          if (user != null) {
            if (user.phoneNumber == "+911234554321") {
              print("object");
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminPage(user: user)));
            } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(user: user)));
            }
          }
        },
        verificationFailed: (FirebaseAuthException exception) {
          // ignore: unnecessary_brace_in_string_interps
          otpFailed = true;
          print("OTP FAILED TO SEND");
          print('Failed + $exception');
          Navigator.pop(context);
          Alert(
              context: context,
              closeFunction: () {
                Navigator.pop(context);
              },
              title: "ERROR",
              content: Column(
                children: [
                  Text("Error Code: ${exception.code.toString()}"),
                  Text("Erro Message: ${exception.message.toString()}"),
                ],
              ),
              buttons: [
                DialogButton(
                  color: Color(0xFFf1c40f),
                  onPressed: () async {},
                  child: Text(
                    "Confirm",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ]).show();
        },
        codeSent: (verificationId, [int forceResendingToker]) {
          // popup for entering the amount
          Alert(
              context: context,
              title: "OTP",
              closeFunction: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              content: Column(
                children: <Widget>[
                  TextField(
                    onChanged: (value) {
                      otpcode = value;
                      print(otpcode);
                    },
                    keyboardType: TextInputType.number,
                    controller: codeController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Please wait while we send OTP.',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
              buttons: [
                DialogButton(
                  color: Color(0xFFf1c40f),
                  onPressed: () async {
                    openLoadingDialoge(); // open loading
                    AuthCredential credential = PhoneAuthProvider.credential(
                        verificationId: verificationId, smsCode: otpcode);
                    UserCredential result =
                        await _auth.signInWithCredential(credential);
                    User user = result.user;
                    if (user != null) {
                      loadingState = true; // close loading if no user

                      if (user.phoneNumber == "+911234554321") {
                        print("object");
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminPage(user: user)));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(user: user)));
                      }
                    } else {
                      loadingState = true; // close loading for error

                      print('error');
                    }
                  },
                  child: Text(
                    "Confirm",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ]).show();
        },
        codeAutoRetrievalTimeout: (verificationId) {});
  }

  _onClear() {
    setState(() {
      phoneController = TextEditingController(text: '+91');
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
                                      color: Color(0xFFf1c40f)),
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
                                      style:
                                          TextStyle(color: Color(0xFFf1c40f))),
                                  TextSpan(
                                      text: 'One Time Password ',
                                      style: TextStyle(
                                          color: Color(0xFFf1c40f),
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: 'on this mobile number',
                                      style:
                                          TextStyle(color: Color(0xFFf1c40f))),
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
                            openLoadingDialoge(); // open loading
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
                          color: Color(0xFFf1c40f),
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
                                    color: Color(0xFFf1c40f),
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
