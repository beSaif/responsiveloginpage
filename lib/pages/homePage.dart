import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/pages/funds.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  User user;
  HomePage({this.user});
  @override
  _HomePageState createState() => _HomePageState(user);
}

class _HomePageState extends State<HomePage> {
  bool loadingscreen = false;
  User user;

  // firebase section.
  Map coinPriceLive = {
    "lastPrice": 0,
    "currentPrice": 0
  }; //! sample data illank app crash aaan
  void getCoinPrice() async {
    CollectionReference coinPriceRef = FirebaseFirestore.instance
        .collection("coinPrice"); // firebase storeage location
    // fetching coin price
    await coinPriceRef.get().then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) => {
                setState(() {
                  coinPriceLive =
                      doc.data(); //finds the value and stores in the variable
                }),
              }),
          //print(coinPriceLive)
        });
  }

  Map currentUser = {
    "name": " ",
    "number": 0,
    "RC": 0,
    "walletBalance": 0,
    "walletHistory": [],
    "coinHistory": []
  }; //! basic templaet illank app crash aaan for some reason
  //fetching userDetainls
  void getCurrentUser(String uid) async {
    CollectionReference userRef = FirebaseFirestore.instance
        .collection("users"); // firebase location of users
    userRef.doc(uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('user found: ${documentSnapshot.data()}');
        setState(() {
          currentUser = documentSnapshot.data();
        });
      } else {
        print('no user found, don\'t worry machane we can create');
        // creating the new user for the database with his uid
        userRef.doc(uid).set({
          "name": " ",
          "number": user.phoneNumber,
          "RC": 0,
          "walletBalance": 0,
          "uid": "${uid}",
          "walletHistory": [],
          "coinHistory": []
        });
      }
    });
  }

  //coin percentage calculator
  String coinPercentage() {
    int currentPrice = coinPriceLive["currentPrice"];
    int lastPrice = coinPriceLive["lastPrice"];
    double percentage = ((currentPrice - lastPrice) / lastPrice) * 100;
    String returnValue;
    if (percentage > 0) {
      returnValue = "+" + percentage.toStringAsFixed(2);
      return returnValue;
    } else {
      returnValue = percentage.toStringAsFixed(2);
      return returnValue;
    }
  }

  // coin % card background color
  double coinPercentageColor() {
    int currentPrice = coinPriceLive["currentPrice"];
    int lastPrice = coinPriceLive["lastPrice"];
    double percentage = ((currentPrice - lastPrice) / lastPrice) * 100;
    return percentage;
  }

  @override
  void initState() {
    getCoinPrice(); // auto fetching for the first time
    getCurrentUser(user.uid); //auto fetching the user
    super.initState();
  }

  _HomePageState(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.account_balance_wallet),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FundsPage(currentUser: currentUser)));
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              getCoinPrice();
              getCurrentUser(user.uid);
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Color(0xFF0B3954),
        brightness: Brightness.light,
        centerTitle: true,
        title: Text(
          'RICH COIN',
        ),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Container(
        color: Color(0xFFf8f8ff),
        padding: EdgeInsets.only(bottom: 00),
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: Color(0xFF0B3954),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40))),
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Holdings Value',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              'INR',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₹${coinPriceLive["currentPrice"] * currentUser["RC"]}', // taking elements from the current user map
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: coinPercentageColor() > 0
                                      ? Color(0xFF2ECC71)
                                      : Color(0xFFdf514d),
                                  borderRadius: BorderRadius.circular(20)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Text(
                                "${coinPercentage()}%",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ' ${currentUser["RC"].toString()} RC',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${currentUser["number"].toString()}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                          colors: [Color(0xFFe67e22), Color(0xFFf1c40f)])),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            'BUY',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        color: Color(0xFF4185f4),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          'SELL',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        color: Color(0xFFdf514d),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                alignment: Alignment.topLeft,
                child: Text(
                  'Transaction History',
                  style: TextStyle(fontSize: 22),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.topLeft,
                child: Container(
                  child: ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 13),
                          height: 76,
                          padding: EdgeInsets.only(
                              left: 24, top: 12, bottom: 12, right: 22),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFFdfdfe5),
                                    blurRadius: 10,
                                    spreadRadius: 5,
                                    offset: Offset(8, 8))
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    height: 57,
                                    width: 57,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF4185f4)),
                                    child: Text(
                                      'B',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 13,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "5 RC",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '13-08-2020',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'Montserrat',
                                          color: Colors.grey[10],
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '₹500',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Montserrat',
                                      color: Color(0xFF0B3954),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
