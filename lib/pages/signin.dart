import 'package:chat_app/pages/home.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class SignIn extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignIn> {
  bool isLoading = false;
  var devWidth;
  var devheight;
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();
  final formKey = GlobalKey<FormState>();

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyColors.primColor,
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: devheight * 0.35,
                        width: devWidth,
                        child: topbar(),
                        decoration: BoxDecoration(
                          color: MyColors.primColor,
                        ),
                      ),
                      Container(
                        height: 700,
                        width: devWidth,
                        child: BtnWidget(),
                        decoration: BoxDecoration(
                            color: MyColors.secColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(29))),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget topbar() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/signup.png',
            height: devheight * 0.1,
          ),
          SizedBox(
            height: devheight * 0.02,
          ),
          Text(
            'Welcome to ChatApp',
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                  color: MyColors.secColor, fontSize: devheight * 0.03),
            ),
          ).shimmer(
              primaryColor: MyColors.secColor,
              secondaryColor: MyColors.primColor.withOpacity(0.8),
              duration: Duration(seconds: 3)),
          SizedBox(
            height: devheight * 0.02,
          ),
          Text(
            'Sign In',
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                  color: MyColors.secColor, fontSize: devheight * 0.04),
            ),
          ),
          Text(
            'to continue...',
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                color: MyColors.secColor.withOpacity(0.5),
                fontSize: devheight * 0.02,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget BtnWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        children: [
          Column(
            children: [
              SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  isLoading = !isLoading;
                  setState(() {});
                  AuthMethods().SignInWithGoogle(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: MyColors.primColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/google.png",
                        height: 30,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Sign In with Google",
                        style: GoogleFonts.lato(
                            color: MyColors.secColor,
                            fontSize: devheight * 0.02),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  // signIn();
                  //signMeUp();
                  print("hello fb");
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: MyColors.primColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/fb.png",
                        height: 30,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Sign In with Facebook",
                        style: GoogleFonts.lato(
                            color: MyColors.secColor,
                            fontSize: devheight * 0.02),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
