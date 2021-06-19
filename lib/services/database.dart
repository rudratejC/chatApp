import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  //for adding user data dto firestore on google sign in
  Future addUserInfoToDB(
      String userId, Map<String, dynamic> userInfoMap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }

  //for getting users by name for search
  getUserByName(String name) {
    return FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: name)
        .snapshots();
  }

  //For adding new Messages to db
  Future addMessage(
      String chatRoomId, String messageId, Map messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessageSend(String chatRoomId, Map lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .set(lastMessageInfoMap, SetOptions(merge: true));
  }

  createChatRoom(String chatRoomId, Map chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      // chatroom already exists
      return true;
    } else {
      // chatroom does not exists
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }
}
// Future<void> uploadUserInfo(userData) async {
//     FirebaseFirestore.instance
//         .collection("users")
//         .add(userData)
//         .catchError((e) {
//       print(e.toString());
//     });
//   }

//   getUserInfo(String email) async {
//     return FirebaseFirestore.instance
//         .collection("users")
//         .where("email", isEqualTo: email)
//         .get()
//         .catchError((e) {
//       print(e.toString());
//     });
//   }

//   searchByName(String searchField) {
//     return FirebaseFirestore.instance
//         .collection("users")
//         .where('name', isEqualTo: searchField)
//         .get();
//   }
