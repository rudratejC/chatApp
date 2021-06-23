import 'package:chat_app/helper/sharedpref_helper.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_string/random_string.dart';

class ChatScreen extends StatefulWidget {
  final String chatWithUsername, name, profileurl;
  Stream messageStream;
  ChatScreen(this.chatWithUsername, this.name, this.profileurl);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatRoomId, messageId = "";
  Stream messageStream;
  String myName, myProfilePic, myUserName, myEmail;
  TextEditingController messageTextEdittingController = TextEditingController();

  getMyInfoFromSharedPreference() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();

    chatRoomId = getChatRoomIdByUsernames(widget.chatWithUsername, myUserName);
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  addMessage(bool sendClicked) {
    if (messageTextEdittingController.text != "") {
      String message = messageTextEdittingController.text;

      var lastMessageTs = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "ts": lastMessageTs,
        "imgUrl": myProfilePic
      };

      //messageId
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }

      DatabaseMethods()
          .addMessage(chatRoomId, messageId, messageInfoMap)
          .then((value) {
        var usersList = chatRoomId.split("_");
        var SendigUserName = "$myUserName\Name";
        var RecivingUserName = "${widget.chatWithUsername}\Name";
        var SendigUserPic = "$myUserName\Pic";
        var RecivingUserPic = "${widget.chatWithUsername}\Pic";
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": myUserName,
          "users": usersList,
          SendigUserName: myName,
          SendigUserPic: myProfilePic,
          RecivingUserName: widget.name,
          RecivingUserPic: widget.profileurl
        };

        DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);

        if (sendClicked) {
          messageTextEdittingController.text = "";
          messageId = "";
        }
      });
    }
  }

  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomRight:
                      sendByMe ? Radius.circular(0) : Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft:
                      sendByMe ? Radius.circular(24) : Radius.circular(0),
                ),
                color: sendByMe ? MyColors.myMsgColor : MyColors.othersMsgColor,
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                message,
                style: TextStyle(
                    //fontSize: MediaQuery.of(context).size.width * 0.04,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
        ),
      ],
    );
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 70, top: 16),
                reverse: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return chatMessageTile(
                      ds["message"], myUserName == ds["sendBy"]);
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  getAndSetMessages() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  doThisOnLaunch() async {
    await getMyInfoFromSharedPreference();
    getAndSetMessages();
  }

  @override
  void initState() {
    doThisOnLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.chatBGColor,
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                widget.profileurl,
                height: 40,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text(widget.name),
          ],
        ),
        backgroundColor: MyColors.primColor,
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: MyColors.primColor,
                  borderRadius: BorderRadius.circular(40),
                ),
                padding: EdgeInsets.only(left: 16, right: 6),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messageTextEdittingController,
                      // onChanged: (value) {
                      //   addMessage(false);
                      // },
                      style: TextStyle(color: MyColors.secColor),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type a message",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: MyColors.secColor.withOpacity(0.4))),
                    )),
                    SizedBox(
                      width: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        addMessage(true);
                        print(
                            "send clicked! ${messageTextEdittingController.text}");
                        setState(() {});
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: MyColors.myMsgColor,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(
                          Icons.send,
                          color: MyColors.secColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
