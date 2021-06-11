import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserInfoToDB(
      String userId, Map<String, dynamic> userInfoMap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
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