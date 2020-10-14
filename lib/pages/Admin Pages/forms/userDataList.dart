import 'package:flutter/material.dart';

class UserDataList extends StatefulWidget {
  @override
  _UserDataListState createState() => _UserDataListState();
}

class _UserDataListState extends State<UserDataList> {
  String name = "John";
  String phoneNumber = "+919995015935";

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        primary: false,
        reverse: true,
        itemCount: 50,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 13, left: 20, right: 20),
            height: 100,
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
                        color: Color(0xFF4185f4),
                      ), // TODO: Change Circle Color based on type
                      child: Text(
                        "${name[0]}",
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
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'RC: ${5}',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Montserrat',
                            color: Colors.grey[10],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Balance: ₹${4965}',
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
                      phoneNumber,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
