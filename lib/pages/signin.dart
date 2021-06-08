import 'package:chat_app/pages/chatRooms.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn(this.toggleView);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  var devWidth;
  var devheight;
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  // TextEditingController usernameEditingController =
  //     new TextEditingController();
  final formKey = GlobalKey<FormState>();

  AuthMethods authMethods = new AuthMethods();
  signMeIn() {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      authMethods
          .signInWithEmailAndPassword(
              emailEditingController.text, passwordEditingController.text)
          .then((value) {
        print("we got $value from firebase");
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ChatRoom()));
    }
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyColors.primColor,
      body: SingleChildScrollView(
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
                child: formWidget(),
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

  Widget formWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  validator: (val) {
                    return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val)
                        ? null
                        : "Please Enter Correct Email";
                  },
                  controller: emailEditingController,
                  style: simpleTextStyle(),
                  decoration: textFieldInputDecoration("Enter email"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: true,
                  validator: (val) {
                    return val.length > 6
                        ? null
                        : "Enter Password 6+ characters";
                  },
                  style: simpleTextStyle(),
                  controller: passwordEditingController,
                  decoration: textFieldInputDecoration("Enter password"),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ForgotPassword()));
                      },
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            "Forgot Password?",
                            style: simpleTextStyle(),
                          )),
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    signMeIn();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: MyColors.primColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Sign In",
                      style: GoogleFonts.lato(
                          color: MyColors.secColor, fontSize: devheight * 0.02),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: MyColors.primColor),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Sign In with Google",
                    style: GoogleFonts.lato(
                        color: MyColors.secColor, fontSize: devheight * 0.02),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have account? ",
                      style: simpleTextStyle(),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.toggleView();
                      },
                      child: Text(
                        "Register now",
                        style: GoogleFonts.lato(
                            color: MyColors.primColor,
                            fontSize: 16,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// paste this in widgets after completing

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: GoogleFonts.lato(color: Colors.black54),
    border: new OutlineInputBorder(
      borderRadius: new BorderRadius.circular(25.0),
      borderSide: new BorderSide(),
    ),
  );
}

TextStyle simpleTextStyle() {
  return GoogleFonts.lato(
      textStyle: TextStyle(color: MyColors.primColor, fontSize: 16));
}
