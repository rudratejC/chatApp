import 'package:chat_app/helper/sharedpref_helper.dart';

import 'package:chat_app/pages/chatScreen.dart';
import 'package:chat_app/pages/signin.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

Stream chatRoomsStream;

class _HomeState extends State<Home> {
  bool isSearching = false;
  TextEditingController searchTextEditingController = TextEditingController();
  Stream userStream;

  String myName, myProfilePic, myUserName, myEmail;

  getMyInfoFromSharedPreference() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b/_$a";
    } else {
      return "$a/_$b";
    }
  }

  getChatRooms() async {
    chatRoomsStream = await DatabaseMethods().getChatRooms();
    setState(() {});
  }

  onScreenLoaded() async {
    await getMyInfoFromSharedPreference();
  }

  getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myUserName = prefs.getString("USERNAMEKEY");
  }

  @override
  void initState() {
    getUserName();
    onScreenLoaded();
    getChatRooms();
    setState(() {});
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: MyColors.primColor,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));
    super.initState();
  }

  callHomesInit() {
    initState();
  }

  onSearchBtnClicked() async {
    if (myUserName == null) {
      myUserName = await SharedPreferenceHelper().getUserName();
    }
    var searchQuery = searchTextEditingController.text != myName
        ? searchTextEditingController.text
        : "${searchTextEditingController.text}__";
    userStream = await DatabaseMethods().getUserByName(searchQuery);
    setState(() {});
  }

  searchBtnResponse() {
    isSearching = !isSearching;
    setState(() {});
  }

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  //return ChatRoomListTile(ds["lastMessage"], ds.id, myUserName);
                  // return Text(
                  //   ds.id.replaceAll(myUserName, "").replaceAll("_", ""),
                  //   style: chatTileStyle(),
                  // );
                  var uName =
                      ds.id.replaceAll(myUserName, "").replaceAll("_", "");
                  return ChatRoomListTile(
                      chatRoomId: ds.id,
                      chatWithUsername: uName,
                      recieverName: ds["$uName\Name"],
                      reciverPic: ds["$uName\Pic"],
                      lastMessage: ds["lastMessage"]);
                })
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget ChatRoomListTile(
      {chatRoomId, chatWithUsername, recieverName, reciverPic, lastMessage}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChatScreen(chatWithUsername, recieverName, reciverPic)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(
              reciverPic != null
                  ? reciverPic
                  : "https://firebasestorage.googleapis.com/v0/b/booksapp-628fb.appspot.com/o/user.png?alt=media&token=2647095d-fa3e-4f74-aa37-d4997d57406b",
              height: 40,
              width: 40,
            ),
          ),
          title: Text(
            recieverName != null ? recieverName : chatWithUsername,
            style: chatTileStyle(),
          ),
          subtitle: Text(lastMessage),
        ),
      ),
    );
  }

  Widget searchListUserTile(
      {String imgUrl, String name, String email, String username}) {
    return GestureDetector(
      onTap: () {
        var chatRoomId = getChatRoomIdByUsernames(myUserName, username);
        Map<String, dynamic> chatRoomInfoMap = {
          "users": [myUserName, username],
        };

        DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(username, name, imgUrl)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                imgUrl,
                height: 40,
                width: 40,
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),
                Text(email),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget searchUsersList() {
    return StreamBuilder(
        stream: userStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return searchListUserTile(
                        imgUrl: ds["profileUrl"],
                        name: ds["name"],
                        email: ds["email"],
                        username: ds["username"]);
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.secColor,
      body: SingleChildScrollView(
        child: Container(
          color: MyColors.primColor,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 70,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: <Widget>[
                    myProfilePic != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.network(
                              myProfilePic,
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(),
                    SizedBox(
                      width: 12,
                    ),
                    myName != null
                        ? Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text("Hi, $myName!",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      fontWeight: FontWeight.w300),
                                )),
                          )
                        : Container(
                            child: Text("Welcome to ChatApp!",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                )),
                          ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xff444446),
                          borderRadius: BorderRadius.circular(12)),
                      child: GestureDetector(
                        onTap: () {
                          AuthMethods().signOut();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignIn()));
                        },
                        child: Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
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
                                            if (searchTextEditingController
                                                    .text !=
                                                "") {
                                              searchBtnResponse();
                                              onSearchBtnClicked();
                                            }
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
                            isSearching ? searchUsersList() : chatRoomsList(),
                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
