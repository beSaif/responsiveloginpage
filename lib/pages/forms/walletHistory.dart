import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WalletHistory extends StatefulWidget {
  final List walletHistory;
  WalletHistory({Key key, this.walletHistory}) : super(key: key);
  @override
  _WalletHistoryState createState() => _WalletHistoryState();
}

class _WalletHistoryState extends State<WalletHistory> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        primary: false,
        reverse: true,
        itemCount: widget.walletHistory.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 13),
            height: 76,
            padding: EdgeInsets.only(left: 24, top: 12, bottom: 12, right: 22),
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
                        color: widget.walletHistory[index]['type'][0] == "D"
                            ? Color(0xFF4cb050)
                            : Color(0xFF4185f4),
                      ),
                      child: Text(
                        (() {
                          if (widget.walletHistory[index]['type'].toString() ==
                              'Deposited') {
                            return "D";
                          } else {
                            return "W";
                          }
                        }()),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      width: 13,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${widget.walletHistory[index]['type'].toString()}",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(" | "),
                            Text(
                              '${widget.walletHistory[index]['state']}',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: () {
                                    if (widget.walletHistory[index]['state'] ==
                                        "Completed") {
                                      return Colors.green;
                                    }
                                    if (widget.walletHistory[index]['state'] ==
                                        "Processing") {
                                      return Colors.blue;
                                    }
                                    if (widget.walletHistory[index]['state'] ==
                                        "Failed") {
                                      return Colors.red;
                                    }
                                  }()),
                            )
                          ],
                        ),
                        Text(
                          '${widget.walletHistory[index]['time'].toDate()}',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Montserrat',
                            color: Colors.grey[10],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${widget.walletHistory[index]['amount'].toString()}',
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
        });
  }
}
