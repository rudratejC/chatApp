import 'package:chat_app/helper/sharedpref_helper.dart';
import 'package:chat_app/pages/search.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primColor,
      body: Container(
        child: Center(
          child: Text(
            "${SharedPreferenceHelper().getUserEmail().toString()}",
            style: TextStyle(color: MyColors.secColor),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}
