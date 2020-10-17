import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loginpage/pages/Admin%20Pages/forms/withdrawRequestsList.dart';

class WithdrawRequests extends StatefulWidget {
  @override
  _WithdrawRequestsState createState() => _WithdrawRequestsState();
}

class _WithdrawRequestsState extends State<WithdrawRequests> {
  QuerySnapshot queryResults;

  // globals
  CollectionReference userRef = FirebaseFirestore.instance
      .collection("users"); // firebase location of users

  // query the firestore database for wallethistory => state=Processing
  void walletHistoryStateQuery() {
    //press refresh button to call
    userRef
        .where("walletBalance", isGreaterThan: 0)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        queryResults = querySnapshot;
        print(
            "Query Results: ${queryResults.docs[0]["walletHistory"][0]["type"]}");
      });
    });
  }

  itemCount() {
    int count = 0;
    print("userlength:${queryResults.docs.length} ");
    for (var i = 0; i < queryResults.docs.length; i++) {
      print(queryResults.docs[i]["number"]);
      for (var j = 0; j < queryResults.docs[i]["walletHistory"].length; j++) {
        if (queryResults.docs[i]["walletHistory"][j]["state"] == "Processing") {
          count = count + 1;
          print(
              "User: ${queryResults.docs[i]["number"]},Index: ${j},Amount: ${queryResults.docs[i]["walletHistory"][j]["amount"]} ");
        }
      }
    }
    print("final count: $count");
    return count;
  }

  @override
  void initState() {
    walletHistoryStateQuery();
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
              walletHistoryStateQuery();
              itemCount();
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Color(0xFF0B3954),
        brightness: Brightness.light,
        centerTitle: true,
        title: Text(
          'WITHDRAW REQUESTS',
        ),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Color(0xFFf8f8ff),
      body: Container(
          margin: EdgeInsets.only(top: 10),
          color: Color(0xFFf8f8ff),
          width: double.infinity,
          child: SingleChildScrollView(
              child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListView.builder(
                    primary: false,
                    reverse: true,
                    itemCount: itemCount(),
                    shrinkWrap: true,
                    itemBuilder: (
                      context,
                      index,
                    ) {
                      for (var i = 0; i < queryResults.docs.length; i++) {
                        print(queryResults.docs[i]["number"]);
                        for (var j = 0;
                            j < queryResults.docs[i]["walletHistory"].length;
                            j++) {
                          if (queryResults.docs[i]["walletHistory"][j]
                                  ["state"] ==
                              "Processing") {
                            return Text(
                                "User: ${queryResults.docs[i]["number"]},Index: ${j},Amount: ${queryResults.docs[i]["walletHistory"][j]["amount"]} ");
                          }
                        }
                      }
                    }),
              ],
            ),
          ))),
    );
  }
}
