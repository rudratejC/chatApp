import 'package:chat_app/pages/home.dart';
import 'package:chat_app/pages/search.dart';
import 'package:chat_app/pages/signin.dart';
import 'package:chat_app/services/auth.dart';

import 'package:chat_app/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: MyColors.swatch,
      ),
      debugShowCheckedModeBanner: false,
      //home: SignIn(),
      home: FutureBuilder(
          future: AuthMethods().getCurrentUser(),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return Home();
            } else {
              return SignIn();
            }
          }),
      //home: Home(),
    );
  }
}
