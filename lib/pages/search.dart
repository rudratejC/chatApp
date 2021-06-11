// import 'package:chat_app/pages/signin.dart';
// import 'package:chat_app/services/database.dart';
// import 'package:chat_app/utils/colors.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class Search extends StatefulWidget {
//   @override
//   _SearchState createState() => _SearchState();
// }

// class _SearchState extends State<Search> {
//   DatabaseMethods databaseMethods = new DatabaseMethods();
//   TextEditingController searchEditingController = new TextEditingController();
//   QuerySnapshot searchResultSnapshot;

//   bool isLoading = false;
//   bool haveUserSearched = false;

//   initiateSearch() async {
//     if (searchEditingController.text.isNotEmpty) {
//       setState(() {
//         isLoading = true;
//       });
//       await databaseMethods
//           .searchByName(searchEditingController.text)
//           .then((snapshot) {
//         searchResultSnapshot = snapshot;
//         print("$searchResultSnapshot");
//         setState(() {
//           isLoading = false;
//           haveUserSearched = true;
//         });
//       });
//     }
//   }

//   Widget userList() {
//     return haveUserSearched
//         ? ListView.builder(
//             shrinkWrap: true,
//             itemCount: searchResultSnapshot.docs.length,
//             itemBuilder: (context, index) {
//               return userTile(
//                 searchResultSnapshot.docs[index]["name"],
//                 searchResultSnapshot.docs[index]["email"],
//               );
//             })
//         : Container();
//   }

//   Widget userTile(String userName, String userEmail) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       child: Row(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 userName,
//                 style: TextStyle(color: Colors.white, fontSize: 16),
//               ),
//               Text(
//                 userEmail,
//                 style: TextStyle(color: Colors.white, fontSize: 16),
//               )
//             ],
//           ),
//           Spacer(),
//           GestureDetector(
//             onTap: () {},
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               decoration: BoxDecoration(
//                   color: MyColors.swatch,
//                   borderRadius: BorderRadius.circular(24)),
//               child: Text(
//                 "Message",
//                 style: TextStyle(color: Colors.white, fontSize: 16),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   var devWidth;
//   var devheight;

//   @override
//   Widget build(BuildContext context) {
//     devWidth = MediaQuery.of(context).size.width;
//     devheight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: MyColors.primColor,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: MyColors.primColor,
//         title: Text(
//           "Search",
//           style: GoogleFonts.lato(
//             textStyle: TextStyle(
//               color: MyColors.secColor,
//             ),
//           ),
//         ),
//       ),
//       body: isLoading
//           ? Container(
//               child: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             )
//           : Container(
//               padding: EdgeInsets.all(12),
//               child: Column(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(40)),
//                       color: MyColors.swatch.withOpacity(0.5),
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: searchEditingController,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                             ),
//                             decoration: InputDecoration(
//                                 hintText: "search username ...",
//                                 hintStyle: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                 ),
//                                 border: InputBorder.none),
//                           ),
//                         ),
//                         GestureDetector(
//                             onTap: () {
//                               initiateSearch();
//                             },
//                             child: Icon(
//                               Icons.search,
//                               color: MyColors.secColor,
//                             ))
//                       ],
//                     ),
//                   ),
//                   userList()
//                 ],
//               ),
//             ),
//     );
//   }
// }
