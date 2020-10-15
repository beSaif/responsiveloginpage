import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class WithdrawRequests extends StatefulWidget {
  @override
  _WithdrawRequestsState createState() => _WithdrawRequestsState();
}

class _WithdrawRequestsState extends State<WithdrawRequests> {
  // globals
  CollectionReference userRef = FirebaseFirestore.instance
      .collection("users"); // firebase location of users

  // query the firestore database for wallethistory => state=Processing
  void walletHistoryStateQuery() {
    //press refresh button to call
    userRef
        //.where("walletHistory", arrayContains: {"state": "Processing"})
        //.orderBy('_timeStampUTC', descending: true)
        .where("RC", isLessThanOrEqualTo: 5)
        .get()
        .then((QuerySnapshot querySnapshot) {
      print(querySnapshot.docs);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              print("!!!!!!!!!!! call query");
              walletHistoryStateQuery();
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Color(0xFF0B3954),
        brightness: Brightness.light,
        centerTitle: true,
        title: Text(
          'USER DATA',
        ),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Color(0xFFf8f8ff),
      body: Container(
          margin: EdgeInsets.only(top: 10),
          color: Color(0xFFf8f8ff),
          width: double.infinity,
          child: Text("pending withdraw requests")),
    );
  }
}
