import 'package:chat_app/helper/sharedpref_helper.dart';
import 'package:chat_app/pages/search.dart';
import 'package:chat_app/pages/signin.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  bool isSearching = false;
  TextEditingController searchTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primColor,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 70,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.network(
                        "https://lh3.googleusercontent.com/a-/AOh14Ggjx42hiMKcihQNhwabJtlA9hn27LtznrS4tKRP5Q=s96-c",
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text("Hi, Rudratej",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w300),
                        )),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xff444446),
                          borderRadius: BorderRadius.circular(12)),
                      child: Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              /// now stories
              SizedBox(height: 80),

              /// Chats
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 6),
                        child: Column(
                          children: [
                            //search box
                            Row(
                              children: [
                                isSearching
                                    ? GestureDetector(
                                        onTap: () {
                                          searchTextEditingController.clear();
                                          isSearching = !isSearching;
                                          setState(() {});
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: Icon(
                                              Icons.arrow_back_ios_rounded,
                                              color: Colors.grey),
                                        ),
                                      )
                                    : Container(),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: TextField(
                                          controller:
                                              searchTextEditingController,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Search users",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey)),
                                        )),
                                        GestureDetector(
                                          onTap: () {
                                            isSearching = !isSearching;
                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.search,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}


/*
child: Center(
          child: Text(
            "${SharedPreferenceHelper().getUserEmail().toString()}",
            style: TextStyle(color: MyColors.secColor),
          ),
        ),
*/


/*
floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
*/


/*
Row(
                              children: <Widget>[
                                Text(
                                  "Recent",
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.more_vert,
                                  color: Colors.black45,
                                )
                              ],
                            ),
 */