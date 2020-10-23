import 'package:flutter/material.dart';
import 'package:loginpage/size_config.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class WithdrawRequests extends StatefulWidget {
  @override
  _WithdrawRequestsState createState() => _WithdrawRequestsState();
}

class _WithdrawRequestsState extends State<WithdrawRequests> {
  // globals
  QuerySnapshot queryResults;
  CollectionReference userRef = FirebaseFirestore.instance
      .collection("users"); // firebase location of users
  List withdrawRequestsUsers = [];
  Map withdrawUser = {};

  // query the firestore database for wallethistory => state=Processing
  void walletHistoryStateQuery() {
    //press refresh button to call
    userRef
        .where("walletBalance", isGreaterThanOrEqualTo: 0)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        queryResults = querySnapshot;

        itemCount(); // calling the list to get update
      });
    });
  }

  //filtering the by ["state"] == "Processing"
  itemCount() {
    int count = 0;
    // empty the array everytime before adding the elements
    withdrawRequestsUsers = [];

    for (var i = 0; i < queryResults.docs.length; i++) {
      for (var j = 0; j < queryResults.docs[i]["walletHistory"].length; j++) {
        if (queryResults.docs[i]["walletHistory"][j]["state"] == "Processing") {
          count = count + 1;
          // addint the list of requests to the array
          withdrawRequestsUsers.add({
            "number": queryResults.docs[i]["number"],
            "amount": queryResults.docs[i]["walletHistory"][j]["amount"],
            "time": queryResults.docs[i]["walletHistory"][j]["time"],
            "uid": queryResults.docs[i]["uid"],
            "walletBalance": queryResults.docs[i]["walletBalance"],
            "RC": queryResults.docs[i]["RC"],
            "tsid": queryResults.docs[i]["walletHistory"][j]["tsid"]
          });
        }
      }
    }
    return count;
  }

  //update the withdraw reqts [state] == whateverispassed
  void updateWithdrawReq(uid, tsid, state) {
    print("user: ${uid}, tsid ${tsid},changed to ${state}");

    //get the copy object by uid
    userRef.doc(uid).get().then((DocumentSnapshot documentSnapshot) {
      withdrawUser = documentSnapshot.data();
    });

    //get the copy of wallethistory array
    List walletHistory = withdrawUser["walletHistory"];

    // loop the wallethistroy and find the map by the TSID thus getting the index and a copy
    //update the index with the copy of the map with only a change in state by state
    int indexOfTsid = 0;
    walletHistory.forEach((element) {
      if (tsid == element["tsid"]) {
        print(element);
        element["state"] = state;
        print(element);
        //TODO update this somehow in firestore

        // userRef.doc(uid).update({
        //   "walletHistory": FieldValue.arrayUnion([element])
        // });
      }
      return indexOfTsid += 1;
    });

    //refresh everthing so that firestore and we are on the same page
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
              // print("printing ${withdrawRequestsUsers}");
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
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    child: ListView.builder(
                        primary: false,
                        reverse: true,
                        itemCount: withdrawRequestsUsers.length,
                        shrinkWrap: true,
                        itemBuilder: (
                          context,
                          index,
                        ) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 13),
                            height: 100,
                            padding: EdgeInsets.only(
                                left: 24, top: 12, bottom: 12, right: 24),
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
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${withdrawRequestsUsers[index]["number"]}',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          'RC ${withdrawRequestsUsers[index]["RC"].toString()}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Montserrat',
                                            color: Colors.grey[10],
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          'Balance: ₹${withdrawRequestsUsers[index]["walletBalance"].toString()}',
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
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "₹${withdrawRequestsUsers[index]["amount"].toString()}",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            InkWell(
                                              child: Icon(
                                                Icons.check,
                                                size: 30,
                                                color: Colors.green,
                                              ),
                                              onTap: () {
                                                updateWithdrawReq(
                                                    withdrawRequestsUsers[index]
                                                        ["uid"],
                                                    withdrawRequestsUsers[index]
                                                        ["tsid"],
                                                    "Completed");
                                              },
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              child: Icon(
                                                Icons.not_interested,
                                                size: 25,
                                                color: Colors.red,
                                              ),
                                              onTap: () {
                                                updateWithdrawReq(
                                                    withdrawRequestsUsers[index]
                                                        ["uid"],
                                                    withdrawRequestsUsers[index]
                                                        ["tsid"],
                                                    "Failed");
                                              },
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 15,
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        })),
              ],
            ),
          )),
    );
  }
}
