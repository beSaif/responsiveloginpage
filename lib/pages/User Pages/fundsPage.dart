import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/pages/forms/walletHistory.dart';
import 'package:loginpage/size_config.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

class FundsPage extends StatefulWidget {
  Map currentUser;
  FundsPage({Key key, this.currentUser}) : super(key: key);
  @override
  _FundsPageState createState() => _FundsPageState();
}

class _FundsPageState extends State<FundsPage> {
  TextEditingController textEditingController =
      new TextEditingController(); //text controller for getting the amount

  // rabeeh's section for razorpay integration.
  Razorpay razorpay;
  @override
  void initState() {
    // List walletHistory = widget.currentUser['wallethistory'];
    // walletHistory.forEach((value) => print('value:$value'));

    razorpay = new Razorpay();
    // razorpay checking all states
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

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
        "Complete"); // passing the amount to get updated in the firestore
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

    Map updateWalletHistory = {
      "time": DateTime.now(),
      "amount": amount,
      "type": type,
      "state": state,
    };
    CollectionReference userRef =
        FirebaseFirestore.instance.collection("users");
    userRef.doc(widget.currentUser["uid"]).update({
      "walletBalance": updatedAmount,
      "walletHistory": FieldValue.arrayUnion([updateWalletHistory])
    });
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
        ),
        backgroundColor: Color(0xFFf8f8ff),
        body: Container(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 40),
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
                                          icon: Text("\u20B9"), // rupee icon
                                          labelText: 'Amount',
                                        ),
                                      ),
                                    ],
                                  ),
                                  buttons: [
                                    DialogButton(
                                      onPressed: () => {
                                        openCheckout("payment"),
                                        Navigator.pop(context)
                                      },
                                      child: Text(
                                        "ADD",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                          SizeConfig.blockSizeHorizontal * 3.3),
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
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
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
                      if (widget.currentUser['walletHistory'].length == 0) {
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
                        return WalletHistory(currentUser: widget.currentUser);
                      }
                    }())),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
