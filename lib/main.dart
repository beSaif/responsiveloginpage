import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/pages/phoneAuthPage.dart';
import 'package:loginpage/size_config.dart';
import 'pages/signup.dart';
import 'package:flutter/services.dart';
import 'pages/login.dart';

Future<void> main() async {
/*   WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); */
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(DevicePreview(
    builder: (context) => MyApp(),
  ));

/*   runApp(MyApp()); */
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignUpPage(),
        '/PhoneAuthPage': (BuildContext context) => new PhoneAuthPage(),
      },
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return LogInPage();
  }
}
