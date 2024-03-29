import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loginpage/pages/forms/walletHistory.dart';
import 'package:loginpage/size_config.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

class FundsPage extends StatefulWidget {
  Map currentUser;
  FundsPage({Key key, this.currentUser}) : super(key: key);
  @override
  _FundsPageState createState() => _FundsPageState();
}

class _FundsPageState extends State<FundsPage> {
  TextEditingController textEditingController =
      new TextEditingController(); //text controller for getting the amount

  // globals
  CollectionReference walletHistoryRef =
      FirebaseFirestore.instance.collection("walletHistory");
  CollectionReference userRef = FirebaseFirestore.instance.collection("users");
  Razorpay razorpay;
  var uuid = Uuid();
  QuerySnapshot querySnapshot;
  List walletHistoryQueryResults = [];
  int checkneg; // to check if amount is negative

  void openCheckout(orderType) {
    var options = {
      "key":
          "rzp_test_NuHYDNYey0a6aH", //  keys "rzp_test_NuHYDNYey0a6aH" => test api, "rzp_live_D5pmfqctPDbERt" => real api
      "amount": num.parse(textEditingController.text) *
          100, // this is because passing 100 directly will be 1 rupee (calculated in paisa)
      "entry": orderType, // here we can ask for refund or normal payment
      "name": "Sample App",
      "description": "Payment for the some random product",
      "prefill": {
        "email": "someone@example.com", // or user.email
        "phone": "9895989598"
      },
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  // functions for checking the payment states
  void handlerPaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment success");
    updateWallet(int.parse(textEditingController.text), "Deposited",
        "Completed"); // passing the amount to get updated in the firestore
    Toast.show(
      //will show a small feedback to user about the payment
      "Payment Success",
      context,
      duration: Toast.LENGTH_LONG, backgroundColor: Colors.green[200],
    );
  }

  void handlerErrorFailure(PaymentFailureResponse response) {
    print("Payment Failed");
    Toast.show(
      "Payment Failed",
      context,
      duration: Toast.LENGTH_LONG,
      backgroundColor: Colors.red[200],
    );
  }

  void handlerExternalWallet(ExternalWalletResponse response) {
    print("Payment Wallet");
    Toast.show("Payment External Wallet", context,
        duration: Toast.LENGTH_LONG, backgroundColor: Colors.blue[200]);
  }

  //wallethistory querying for list render
  // query the firestore database for wallethistory => state=Processing
  Future walletHistoryQuery() async {
    //press refresh button to call
    await walletHistoryRef
        .where("uid", isEqualTo: widget.currentUser["uid"])
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        querySnapshot = querySnapshot;
        // calling the list to get update
        walletHistoryQueryResults = querySnapshot.docs.toList();
        print(
            "walletHistoryQueryResults Available: $walletHistoryQueryResults");
      });
    });
  }

  //firebase funtion to update wallet
  void updateWallet(int amount, String type, String state) {
    print('updating wallet of ${widget.currentUser["uid"].toString()}');
    int updatedAmount = widget.currentUser["walletBalance"];

    // calculating the amount to update
    if (type == "Deposited") {
      updatedAmount = widget.currentUser["walletBalance"] + amount;
    } else if (type == "Withdraw") {
      updatedAmount = widget.currentUser['walletBalance'] - amount;
    }

    // calculating the amount to update

    userRef.doc(widget.currentUser["uid"]).update({
      "walletBalance": updatedAmount,
    });

    //wallethistory collection adding the new doc

    String tsid = uuid.v4();

    walletHistoryRef.doc(tsid).set({
      "time": DateTime.now(),
      "amount": amount,
      "type": type,
      "state": state,
      "tsid": tsid,
      "uid": widget.currentUser["uid"],
      "RC": widget.currentUser["RC"],
      "walletBalance": updatedAmount,
      "number": widget.currentUser["number"],
    });

    //refresh part
    walletHistoryQuery();
    refreshUserData(widget.currentUser["uid"]);
    textEditingController.clear();
    withdrawAmountController.clear();
  }

  void refreshUserData(String uid) {
    CollectionReference userRef =
        FirebaseFirestore.instance.collection("users");
    userRef.doc(uid).get().then((DocumentSnapshot documentSnapshot) {
      setState(() {
        widget.currentUser = documentSnapshot.data();
      });
    });
  }

  // withdraw button popups
  TextEditingController withdrawAmountController = new TextEditingController();
  Future withdrawAmount() {
    withdrawAmountController = TextEditingController(text: '');
    String feedback = "Enter amount";
    return Alert(
        context: context,
        title: "Withdraw",
        content: Column(
          children: <Widget>[
            Container(
              child: TextField(
                controller: withdrawAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  icon: Icon(Icons.attach_money),
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
              int amount = int.parse(withdrawAmountController.text);
              if (amount < 0) {
                print("zero");
              } else {
                // is there balace amount check
                if (amount <= widget.currentUser['walletBalance']) {
                  // update everything function call
                  updateWallet(int.parse(withdrawAmountController.text),
                      "Withdraw", "Processing");
                  Navigator.pop(context);
                } else {
                  // no balace in account
                  Navigator.pop(context);
                  Alert(
                      context: context,
                      title: "YOU DON'T HAVE SUFFICIENT BALANCE",
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
                      ]).show();
                }
              }
            },
            child: Text(
              "WITHDRAW",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500),
            ),
          )
        ]).show();
  }

  Future walletBalanceCalculator() async {
    if (walletHistoryQueryResults.isEmpty) {
      print("walletHistoryQueryResults empty");
    } else {
      print("Calculator Started");
      print("walletHistoryQueryResults not empty");
      int count = walletHistoryQueryResults.length;
      int dcompleted = 0;
      int wcompleted = 0;
      int processing = 0;
      int failed = 0;
      int walletBalanceSum = 0;
      for (int i = 0; i < count; i++) {
        if (walletHistoryQueryResults[i]['uid'] == widget.currentUser['uid']) {
          walletBalanceSum = walletBalanceSum + 1;
          if (walletHistoryQueryResults[i]['type'] == "Deposited") {
            dcompleted = walletHistoryQueryResults[i]['amount'] + dcompleted;
          }
          if (walletHistoryQueryResults[i]['type'] == "Withdraw" &&
              walletHistoryQueryResults[i]['state'] == "Completed") {
            wcompleted = walletHistoryQueryResults[i]['amount'] + wcompleted;
          }
          if (walletHistoryQueryResults[i]['type'] == "Withdraw" &&
              walletHistoryQueryResults[i]['state'] == "Processing") {
            processing = walletHistoryQueryResults[i]['amount'] + processing;
          }
          if (walletHistoryQueryResults[i]['type'] == "Withdraw" &&
              walletHistoryQueryResults[i]['state'] == "Failed") {
            failed = walletHistoryQueryResults[i]['amount'] + failed;
          }
        }
      }
      print("No. of transactions: $walletBalanceSum");
      print("Deposited Completed: $dcompleted");
      print("Withdraw Completed: $wcompleted");
      print("Withdraw Processing: $processing");
      print("Withdraw Failed: $failed");

      walletBalanceSum = ((dcompleted) - (wcompleted + processing));

      print("Wallet Balance: $walletBalanceSum");
      userRef.doc(widget.currentUser["uid"]).update({
        "walletBalance": walletBalanceSum,
      });

      return walletBalanceSum;
    }
  }

  Future newinitstate() async {
    //newinitstate because can't use await in initstate
    await walletHistoryQuery();
    await walletBalanceCalculator();
    print("Widget Wallet Balance: ${widget.currentUser['walletBalance']}");
  }

  @override
  void initState() {
    razorpay = new Razorpay();
    // razorpay checking all states
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
    //get query for list rendering else will crash
    newinitstate();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop(widget.currentUser);
              },
            ),
            elevation: 0,
            backgroundColor: Color(0xFF0B3954),
            brightness: Brightness.light,
            centerTitle: true,
            title: Text(
              'FUNDS',
            ),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  walletBalanceCalculator();
                },
              ),
            ]),
        backgroundColor: Color(0xFFf8f8ff),
        body: (() {
          if (walletHistoryQueryResults == null) {
            // walletHistoryQuery();
            // walletBalanceCalculator();
            return Container(
              child: Center(
                  child: SpinKitFadingCube(
                color: Colors.yellow,
              )),
            );
          } else {
            return Container(
              color: Color(0xFFf8f8ff),
              padding: EdgeInsets.only(bottom: 00),
              width: MediaQuery.of(context).size.width,
              child: Container(
                height: double.infinity,
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
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Wallet Balance',
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
                                margin: EdgeInsets.only(bottom: 35),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '₹${widget.currentUser['walletBalance'].toString()}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
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
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        'ADD FUNDS',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                SizeConfig.blockSizeHorizontal *
                                                    3.3),
                                      ),
                                    ],
                                  ),
                                ),
                                color: Color(0xFF4cb050),
                                onPressed: () {
                                  // popup for entering the amount
                                  Alert(
                                      context: context,
                                      title: "DEPOSIT",
                                      content: Column(
                                        children: <Widget>[
                                          TextField(
                                            controller: textEditingController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              icon:
                                                  Text("\u20B9"), // rupee icon
                                              labelText: 'Amount',
                                            ),
                                          ),
                                        ],
                                      ),
                                      buttons: [
                                        DialogButton(
                                          onPressed: () {
                                            int amount = int.parse(
                                                textEditingController.text);
                                            if (amount < 0) {
                                              print('zero');
                                            } else {
                                              openCheckout("payment");
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Text(
                                            "ADD",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        )
                                      ]).show();
                                },
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'WITHDRAW',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal *
                                                  3.3),
                                    ),
                                  ],
                                ),
                                color: Color(0xFF4185f4),
                                onPressed: () {
                                  List walletHistory =
                                      widget.currentUser["walletHistory"];
                                  print(walletHistory);
                                  withdrawAmount();
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Wallet History',
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.topLeft,
                        child: Container(
                            child: (() {
                          if (walletHistoryQueryResults.length == 0) {
                            return Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 13),
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
                            return WalletHistory(
                                walletHistory: walletHistoryQueryResults);
                          }
                        }())),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }()));
  }
}
