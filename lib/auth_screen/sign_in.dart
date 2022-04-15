import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:eat_it_ppsu/auth_screen/forgot_pass.dart';
import 'package:eat_it_ppsu/auth_screen/sign_up.dart';
import 'package:eat_it_ppsu/drawer/home.dart';
import 'package:eat_it_ppsu/images_link.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../style.dart';

class SignIn extends StatelessWidget {
  SignIn({Key? key}) : super(key: key);

  bool? _isUserExist;
  TextEditingController signin_phone = TextEditingController();
  TextEditingController signin_password = TextEditingController();
  final fs = FirebaseFirestore.instance;

  GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //----------------------------------------------------------------------------- background image
        Container(
          //background image
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(images.home_food),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.6), BlendMode.srcOver),
          )),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: _body(
              context), //------------------------------------------------------------ body
        ),
      ],
    );
  }

  _body(BuildContext context) {
    return Column(
      children: [
        //----------------------------------------------------------------------------- back button
        Container(
          margin: EdgeInsets.only(top: 40.h, left: 13.w),
          child: Row(
            children: [
              Icon(Icons.arrow_back_ios, size: 25.sp, color: Colors.white),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    "Back".tr(),
                    style: GoogleFonts.josefinSans(
                        fontSize: 25.sp, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        //----------------------------------------------------------------------------- title
        Container(
          margin: EdgeInsets.only(top: 63.h),
          child: Text(
            "SIGN_IN".tr(),
            style: GoogleFonts.josefinSans(
                color: Colors.white,
                fontSize: 30.sp,
                fontWeight: FontWeight.bold),
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.only(top: 5.sp),
        //   child: Text(
        //     "Enter_your_data".tr(),
        //     style: TextStyle(color: Colors.white, fontSize: 17.sp),
        //   ),
        // ),
        //----------------------------------------------------------------------------- sign in body
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 28.h),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 250.w,
                    height: 50.h,
                    //margin: EdgeInsets.only(top: 22.h),
                    child: TextField(
                      cursorColor: Colors.white,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: textfield,
                      maxLength: 10,
                      controller: signin_phone,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Phone'.tr(),
                        counterText: '',
                        labelStyle: GoogleFonts.josefinSans(
                          fontSize: 20.sp,
                          color: Colors.green,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 250.w,
                    height: 50.h,
                    margin: EdgeInsets.only(top: 10.h),
                    child: TextField(
                      cursorColor: Colors.white,
                      controller: signin_password,
                      obscureText: true,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: textfield,
                      decoration: InputDecoration(
                        labelText: 'Password'.tr(),
                        counterText: '',
                        labelStyle: GoogleFonts.josefinSans(
                          fontSize: 20.sp,
                          color: Colors.green,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 250.w,
                    margin: EdgeInsets.only(top: 12.h),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: ForgotPass())),
                      child: Text(
                        "Forgot Password?".tr(),
                        style: GoogleFonts.josefinSans(
                          fontSize: 16.sp,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                  Container(
                    height: 45.h,
                    width: 250.w,
                    margin: EdgeInsets.only(top: 75.h),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      child: Text(
                        "SIGN_IN".tr(),
                        style: GoogleFonts.montserrat(
                            fontSize: 20.sp, letterSpacing: 0.5.sp),
                      ),
                      onPressed: () async {
                        bool isOnline = await hasNetwork();
                        if (isOnline == true) {
                          if (signin_phone.text.trim().length == 10 &&
                              signin_password.text.trim().length == 6) {
                            alertdialogText(context, "Please_wait...".tr());
                            _isUserExist =
                                await isUserExist(signin_phone.text.trim());
                            if (_isUserExist == true) {
                              await fs
                                  .collection("AllUsers")
                                  .doc(signin_phone.text.trim())
                                  .get()
                                  .then((value) {
                                //print("fs sign in done");
                                String pass = value.get("_password").toString();
                                //print("fs pass : $pass");
                                String UserId = value.get("_uid").toString();

                                if (signin_password.text.trim() == pass) {
                                  SharedPreferences.getInstance().then((value) {
                                    value.setString("UserId", UserId);
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    }
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage()),
                                        (route) => false);
                                  });
                                } else {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                  alertdialog(context,
                                      "Please_Enter_Valid_Password".tr());
                                }
                              });
                            } else {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                              alertdialog(
                                  context,
                                  "User_Not_Exist_With_This_Number!_Please_Sign_Up_First"
                                      .tr());
                            }
                          } else {
                            alertdialog(context,
                                "Enter_valid_Phone_number_and_Password".tr());
                          }
                        } else {
                          alertdialog(
                              context, "Please_check_your_connection".tr());
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Text(
                      "OR",
                      style: GoogleFonts.josefinSans(
                          fontSize: 17.sp, color: Colors.white),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(top: 20),
                  //   child: Text(
                  //     "Sign_in_with".tr(),
                  //     style: GoogleFonts.montserrat(
                  //         fontSize: 20.sp, letterSpacing: 0.5.sp,color: Colors.green),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 15),
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       googleSignIn(context);
                  //     },
                  //     child: Image.asset('assets/images/google.png',height: 60,)
                  //   ),
                  // ),
                  Container(
                    height: 45.h,
                    width: 250.w,
                    margin: EdgeInsets.only(top: 15.h),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset('assets/images/google.png', height: 40),
                            const SizedBox(width: 10),
                            Text(
                              "Sign_in_with_google".tr(),
                              style: GoogleFonts.montserrat(
                                  fontSize: 14.sp, letterSpacing: 0.5.sp),
                            ),
                          ]),
                      onPressed: () {
                        googleSignIn(context);
                      },
                    ),
                  ),
                  // Container(
                  //   height: 45.h,
                  //   width: 250.w,
                  //   margin: EdgeInsets.only(top: 10.h),
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       primary: Color(0xff4169E1),
                  //     ),
                  //     child: Text(
                  //       "Sign_in_with_Facebook".tr(),
                  //       style: GoogleFonts.montserrat(
                  //           fontSize: 18.sp, letterSpacing: 0.5.sp),
                  //     ),
                  //     onPressed: () {
                  //       //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: HomePage()));
                  //     },
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.only(top: 35.h, bottom: 25.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't_have_an_account?".tr(),
                          style: GoogleFonts.josefinSans(
                            color: Colors.white,
                            fontSize: 17.sp,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        const SignUp(),
                                transitionDuration: Duration.zero,
                              ),
                            );
                          },
                          child: Text(
                            "Sign_Up".tr(),
                            style: GoogleFonts.josefinSans(
                                color: Colors.green,
                                fontSize: 17.sp,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> googleSignIn(BuildContext context) async {
    bool isOnline = await hasNetwork();
    if (isOnline == true) {
      alertdialogText(context, "Please_wait...".tr());
      _googleSignIn.signIn().then((value) async {
        _isUserExist = await isUserExist(value!.email);
        if (_isUserExist == true) {
          fs.collection("AllUsers").doc(value.email).get().then((uid) async {
            //print("ajay.tagline uid : ${uid.get("_uid")}");

            await SharedPreferences.getInstance().then((value) {
              value.setString("UserId", uid.get("_uid"));
            });
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false);
          });
        } else {
          final googleAuth = await value.authentication;
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          UserCredential User =
              await FirebaseAuth.instance.signInWithCredential(credential);

          await fs.collection('AllUsers').doc(value.email).set({
            '_uid': User.user!.uid,
            '_phone': value.email,
            '_password': "",
          });

          await fs.collection('UserDetails').doc(User.user!.uid).set({
            "_uid": User.user!.uid,
            "_name": value.displayName,
            "_phone": value.email,
            "_image": value.photoUrl,
          });

          SharedPreferences.getInstance().then((value) async {
            await value.setString("UserId", User.user!.uid);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false);
          });
        }
      }).catchError((e) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        //alertdialog(context, e.toString());
      });
    } else {
      alertdialog(context, "Please_check_your_connection_and_try_again".tr());
    }
  }
}
