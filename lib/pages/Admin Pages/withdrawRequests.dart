import 'package:flutter/material.dart';
import 'package:loginpage/size_config.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class WithdrawRequests extends StatefulWidget {
  @override
  _WithdrawRequestsState createState() => _WithdrawRequestsState();
}

class _WithdrawRequestsState extends State<WithdrawRequests> {
  // globals
  QuerySnapshot querySnapshot;
  CollectionReference userRef = FirebaseFirestore.instance
      .collection("users"); // firebase location of users
  CollectionReference walletHistoryRef =
      FirebaseFirestore.instance.collection("walletHistory");
  List withdrawReqQuery = [];

  // query the firestore database for wallethistory => state=Processing
  void walletHistoryStateQuery() {
    //press refresh button to call
    walletHistoryRef
        .where("state", isEqualTo: "Processing")
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        querySnapshot = querySnapshot;
        withdrawReqQuery = querySnapshot.docs.toList();
      });
    });
  }

  //filtering the by ["state"] == "Processing"

  //update the withdraw reqts [state] == whateverispassed
  void updateWithdrawReq(tsid, state) {
    print("tsid ${tsid},changed to ${state}");

    walletHistoryRef.doc("/" + tsid).update({
      "state": state,
    }); //refresh everthing so that firestore and we are on the same page
    walletHistoryStateQuery();
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
                        itemCount: withdrawReqQuery.length,
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
                                          '${withdrawReqQuery[index]["number"]}',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          'RC ${withdrawReqQuery[index]["RC"].toString()}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Montserrat',
                                            color: Colors.grey[10],
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          'Balance: ₹${withdrawReqQuery[index]["walletBalance"].toString()}',
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
                                          "₹${withdrawReqQuery[index]["amount"].toString()}",
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
                                                    withdrawReqQuery[index]
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
                                                    withdrawReqQuery[index]
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
