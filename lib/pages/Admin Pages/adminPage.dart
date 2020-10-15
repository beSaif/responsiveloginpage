import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/pages/Admin%20Pages/userDataPage.dart';
import 'package:loginpage/pages/login.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AdminPage extends StatefulWidget {
  User user;
  AdminPage({this.user});

  @override
  _AdminPageState createState() => _AdminPageState(user);
}

class _AdminPageState extends State<AdminPage> {
  User user;
  _AdminPageState(this.user);

  int currentPrice;
  int lastPrice;
  int usersnum;

  TextEditingController PriceUpdateController = new TextEditingController();

  Future PricePopup() {
    PriceUpdateController = TextEditingController(text: '');
    String feedback = "Enter new price.";
    return Alert(
        context: context,
        title: "UPDATE COIN PRICE",
        content: Column(
          children: <Widget>[
            Container(
              child: TextField(
                controller: PriceUpdateController,
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
              int newPrice = int.parse(
                  PriceUpdateController.text); //To convert string to int.
              if (newPrice == 0) {
                print("zero");
              }
              print("newPrice: $newPrice");
              updateCoinPrice(newPrice);
              Navigator.pop(context);
            },
            child: Text(
              "CONFIRM",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500),
            ),
          )
        ]).show();
  }

  void getCoinPrice() async {
    FirebaseFirestore.instance
        .collection('coinPrice/')
        .snapshots()
        .listen((data) {
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

  getUserInfo() {
    FirebaseFirestore.instance.collection('users').get().then((users) {
      print("No of users: ${users.docs.length}");
      usersnum = users.docs.length;
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

  ///coin % card background color
  double coinPercentageColor(currentPrice, lastPrice) {
    double percentage = ((currentPrice - lastPrice) / lastPrice) * 100;
    return percentage;
  }

  void updateCoinPrice(int newPrice) {
    int updatedCurrentPrice = newPrice;
    CollectionReference coinRef =
        FirebaseFirestore.instance.collection("coinPrice");
    coinRef.doc("/yi710ZoYNzgk7VAjJMIL").update({
      "lastPrice": currentPrice,
      "currentPrice": updatedCurrentPrice,
    });
  }

  @override
  void initState() {
    getCoinPrice();
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {},
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  getCoinPrice();
                  getUserInfo();
                },
              ),
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogInPage()));
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
          backgroundColor: Color(0xFFf8f8ff),
          body: (() {
            if (usersnum == null) {
              getUserInfo();
              getCoinPrice();
              return Container(
                child: Center(child: CircularProgressIndicator()),
              );
            } else {
              return Container(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ADMIN PANEL',
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              WidgetSpan(
                                                child: Icon(
                                                  Icons.person,
                                                  size: 40,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          usersnum.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: coinPercentageColor(
                                                      currentPrice, lastPrice) >
                                                  0
                                              ? Color(0xFF2ECC71)
                                              : Color(0xFFdf514d),
                                          borderRadius:
                                              BorderRadius.circular(20)),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                              Container(
                                margin: EdgeInsets.only(
                                    right: 30, left: 20, bottom: 0, top: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Last Price : ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Montserrat"),
                                    ),
                                    Text(
                                      '₹$lastPrice',
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
                                height: 30,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'RC',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${user.phoneNumber.toString()}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 40),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(colors: [
                                Color(0xFFe67e22),
                                Color(0xFFf1c40f)
                              ])),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(right: 60, left: 60, bottom: 20),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'UPDATE PRICE',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              color: Color(0xFF4185f4),
                              onPressed: () {
                                PricePopup();
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.people,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'USER DATA',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ],
                              ),
                              color: Color(0xFFdf514d),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserData()));
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Icon(
                                        Icons.money_off,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'WITHDRAW',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              color: Color(0xFF4cb050),
                              onPressed: () {
                                PricePopup();
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.people,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Other',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ],
                              ),
                              color: Color(0xFFdf514d),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserData()));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }())),
    );
  }
}
