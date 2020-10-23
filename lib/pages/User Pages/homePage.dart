import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/main.dart';
import 'package:loginpage/pages/forms/coinHistory.dart';
import 'package:loginpage/pages/User%20Pages/fundsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loginpage/pages/login.dart';
import 'package:loginpage/size_config.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
  int currentPrice;
  int lastPrice;

  Map currentUser = {
    "name": " ",
    "number": 0,
    "RC": 0,
    "walletBalance": 0,
    "walletHistory": [],
    "coinHistory": []
  }; //! basic templaet illank app crash aaan for some reason

  void getCoinPrice() async {
    FirebaseFirestore.instance
        .collection('coinPrice/')
        .snapshots()
        .listen((data) {
      print("DatabySaif: ${data.docs}"); //live Price

      print(currentPrice);
      setState(() {
        currentPrice = data.docs[0]["currentPrice"];
        print("Set State Current Price: $currentPrice");

        lastPrice = data.docs[0]["lastPrice"];
        print("Set State Last Price: $lastPrice");

        coinPercentage(currentPrice, lastPrice);
        coinPercentageColor(currentPrice, lastPrice);
      });
    });
  }

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
          "uid": "$uid",
          "walletHistory": [],
          "coinHistory": []
        });
        getCurrentUser(user.uid);
      }
    });
  }

  //coin percentage calculator
  String coinPercentage(currentPrice, lastPrice) {
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
  double coinPercentageColor(currentPrice, lastPrice) {
    double percentage = ((currentPrice - lastPrice) / lastPrice) * 100;
    return percentage;
  }

  // COIN SECTION BUY AND SELL

  Future coinTransactionPopup(String type) {
    coinNumberController = TextEditingController(text: '');
    String feedback = "Enter quantity.";
    return Alert(
        context: context,
        title: " $type COIN",
        content: Column(
          children: <Widget>[
            Container(
              child: TextField(
                controller: coinNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  icon: Icon(Icons.monetization_on),
                  labelText: feedback,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              int quantity = int.parse(
                  coinNumberController.text); //To convert string to int.
              if (quantity < 0) {
                print("zero");
              } else {
                int totalPrice = quantity * currentPrice;
                Navigator.pop(context); //pops previous dialogue
                return Alert(
                    context: context,
                    title: 'ORDER CONFIRMATION',
                    content: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Quantity: ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Montserrat"),
                                ),
                                Text(
                                  'Total: ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Montserrat"),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  quantity.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Montserrat"),
                                ),
                                Text(
                                  "₹${totalPrice.toString()}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Montserrat"),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    buttons: [
                      DialogButton(
                          child: Text(
                            type,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500),
                          ),
                          onPressed: () {
                            updateType(type, totalPrice, quantity);
                          })
                    ]).show();
              }
            },
            child: Text(
              "NEXT",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500),
            ),
          )
        ]).show();
  }

  updateType(String type, int totalPrice, int quantity) {
    if (type == 'BUY') {
      if (totalPrice <= currentUser['walletBalance'] &&
          currentUser['walletBalance'] != 0) {
        updateTransaction(totalPrice, quantity, type);
      } else {
        Navigator.pop(context);
        Alert(
            context: context,
            title: "YOU DON'T HAVE SUFFICIENT BALANCE",
            content: Text('Please add funds.',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Montserrat")),
            buttons: [
              DialogButton(
                  child: Text("Close",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500)),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              DialogButton(
                  child: Center(
                    child: Text("FUNDS",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500)),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FundsPage(currentUser: currentUser)));
                  })
            ]).show();
      }
    }
    if (type == 'SELL') {
      if (currentUser['RC'] >= quantity &&
          currentUser['RC'] != 0 &&
          quantity != 0) {
        print('Success');
        updateTransaction(totalPrice, quantity, type);
      } else {
        Navigator.pop(context);
        Alert(
            context: context,
            title: "YOU DON'T HAVE SUFFICIENT RC",
            content: Text('Please buy RC.',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Montserrat")),
            buttons: [
              DialogButton(
                  child: Text("Close",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500)),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ]).show();
      }
    }
  }

  //firebase funtion to update transaction
  void updateTransaction(int totalPrice, int quantity, String type) {
    print('updating transactions of ${currentUser["uid"].toString()}');
    if (type == 'BUY') {
      int updatedQuantity =
          currentUser["RC"] + quantity; // calculating the amount to update
      //widget.currentUser["walletBalance"] = updatedAmount; // updating the local copy of walletBalance
      int updatedWalletBalance = currentUser['walletBalance'] - totalPrice;
      Map updateCoinHistory = {
        "time": DateTime.now(),
        "totalPrice": totalPrice,
        "type": type,
        "quantity": quantity,
      };
      CollectionReference userRef =
          FirebaseFirestore.instance.collection("users");
      userRef.doc(currentUser["uid"]).update({
        "walletBalance": updatedWalletBalance,
        "RC": updatedQuantity,
        "coinHistory": FieldValue.arrayUnion([updateCoinHistory])
      });
      refreshUserData(currentUser["uid"]);
      Navigator.pop(context);
    } else if (type == 'SELL') {
      int updatedQuantity =
          currentUser["RC"] - quantity; // calculating the amount to update
      //widget.currentUser["walletBalance"] = updatedAmount; // updating the local copy of walletBalance
      int updatedWalletBalance = currentUser['walletBalance'] + totalPrice;
      Map updateCoinHistory = {
        "time": DateTime.now(),
        "totalPrice": totalPrice,
        "type": type,
        "quantity": quantity,
      };
      CollectionReference userRef =
          FirebaseFirestore.instance.collection("users");
      userRef.doc(currentUser["uid"]).update({
        "walletBalance": updatedWalletBalance,
        "RC": updatedQuantity,
        "coinHistory": FieldValue.arrayUnion([updateCoinHistory])
      });
      refreshUserData(currentUser["uid"]);
      Navigator.pop(context);
    }
  }

  TextEditingController coinNumberController =
      new TextEditingController(); //text controller number of coins

  //buy sell coin updater
  void coinTransaction(int coinPassed, String type) {
    int totalCoins;
    int walletBalance = currentUser["walletBalance"];
    if (type == "BUY") {
      totalCoins = currentUser["RC"] + coinPassed;
      walletBalance = (coinPassed * currentPrice) - walletBalance;
    } else if (type == "SELL") {
      totalCoins = currentUser["RC"] - coinPassed;
      walletBalance = (coinPassed * currentPrice) + walletBalance;
    }

    Map updateCoinHistory = {
      "time": DateTime.now(),
      "coin": coinPassed,
      "type": type,
      //"amount":
    };

    CollectionReference userRef =
        FirebaseFirestore.instance.collection("users");
    userRef.doc(currentUser["uid"]).update({
      "RC": totalCoins,
      "coinHistory": FieldValue.arrayUnion([updateCoinHistory]),
      "walletBalance": walletBalance,
    });
    refreshUserData(currentUser["uid"]);
  }

  // refreshing the transaction to update the list view
  void refreshUserData(String uid) {
    CollectionReference userRef =
        FirebaseFirestore.instance.collection("users");
    userRef.doc(uid).get().then((DocumentSnapshot documentSnapshot) {
      setState(() {
        currentUser = documentSnapshot.data();
      });
    });
    coinNumberController.clear();
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
    return WillPopScope(
      //To deactivate Back Button
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.account_balance_wallet),
            onPressed: () async {
              currentUser = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FundsPage(currentUser: currentUser)));
              if (currentUser == null) {
                getCurrentUser(user.uid);
              }
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
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LogInPage()));
                print(currentUser);
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
        backgroundColor: Color(0xFFf8f8ff), //change this
        body: Container(
          color: Color(0xFFf8f8ff),
          height: double.infinity,
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
                          margin: EdgeInsets.only(
                              bottom: 20, top: 20, right: 30, left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Holdings Value',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              Text(
                                'INR',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
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
                                '₹${currentPrice * currentUser["RC"]}', // taking elements from the current user map
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: coinPercentageColor(
                                                currentPrice, lastPrice) >
                                            0
                                        ? Color(0xFF2ECC71)
                                        : Color(0xFFdf514d),
                                    borderRadius: BorderRadius.circular(20)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Text(
                                  "${coinPercentage(currentPrice, lastPrice)}%",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              right: 30, left: 20, bottom: 0, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Current Price : ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Montserrat"),
                              ),
                              Text(
                                '₹$currentPrice',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Montserrat"),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          color: Color(0xFF4185f4),
                          onPressed: () {
                            coinTransactionPopup("BUY");
                          },
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
                          onPressed: () {
                            coinTransactionPopup("SELL");
                          },
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
                      child: (() {
                    if (currentUser['coinHistory'].length == 0) {
                      return Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 10),
                        child: Text(
                          'No transaction has been done.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      );
                    } else {
                      return CoinHistory(currentUser: currentUser);
                    }
                  }())),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
