import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:eat_it_ppsu/auth_screen/sign_in.dart';
import 'package:eat_it_ppsu/drawer/home.dart';
import 'package:eat_it_ppsu/images_link.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../style.dart';

class OtpVerification extends StatefulWidget {
  final String phone;
  final String name;
  String path;
  OtpVerification({
    Key? key,
    required this.phone,
    required this.path,
    required this.name,
  }) : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final fs = FirebaseFirestore.instance;

  String _verificationCode = "";
  TextEditingController otpcontroller = TextEditingController();
  bool isVisible = false;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String url = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldkey,
      body: Stack(
        children: <Widget>[
          //----------------------------------------------------------------------------- background image
          Container(
            //background image
            decoration: BoxDecoration(
                image: DecorationImage(
              image: const AssetImage(images.home_food),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6), BlendMode.srcOver),
            )),
          ),
          //----------------------------------------------------------------------------- body
          Center(
            child: _body(context),
          ),
          //----------------------------------------------------------------------------- back button
          Container(
            width: 90.w,
            margin: EdgeInsets.only(top: 40.h, left: 13.w),
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, size: 25.sp, color: Colors.white),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      "Back".tr(),
                      style: GoogleFonts.josefinSans(
                          fontSize: 25.sp, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return _verificationCode.isNotEmpty
        ? Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 130.h),
                child: Text(
                  "ENTER_CODE".tr(),
                  style: GoogleFonts.josefinSans(
                      color: Colors.green, fontSize: 30.sp),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "(+91 ${widget.phone}) ",
                      style: GoogleFonts.josefinSans(
                          color: Colors.white, fontSize: 17.sp),
                    ),
                    Text(
                      "from_sms".tr(),
                      style: GoogleFonts.josefinSans(
                          color: Colors.white, fontSize: 17.sp),
                    ),
                  ],
                ),
              ),
              Container(
                width: 250.w,
                height: 50.h,
                margin: EdgeInsets.only(top: 30.h),
                child: TextField(
                  cursorColor: Colors.white,
                  controller: otpcontroller,
                  obscureText: true,
                  autofocus: true,
                  style: textfield,
                  maxLength: 6,
                  onSubmitted: (String value) {
                    otpdone(context, otpcontroller);
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
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
                height: 45.h,
                width: 250.w,
                margin: EdgeInsets.only(top: 100.h),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Text(
                    "DONE".tr(),
                    style: GoogleFonts.montserrat(
                        fontSize: 20.sp, letterSpacing: 0.5.sp),
                  ),
                  onPressed: () async {
                    otpdone(context, otpcontroller);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 35.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Do_not_receive_sms".tr(),
                      style: GoogleFonts.josefinSans(
                        color: Colors.white,
                        fontSize: 17.sp,
                      ),
                    ),
                    //resend(),
                    isVisible
                        ? GestureDetector(
                            onTap: () {
                              verifyPhone();
                              alertdialog(context, "Resend_Message_done".tr());
                              setState(() {
                                isVisible = false;
                              });
                            },
                            child: Text(
                              "Resent".tr(),
                              style: GoogleFonts.josefinSans(
                                  color: Colors.green,
                                  fontSize: 17.sp,
                                  decoration: TextDecoration.underline),
                            ),
                          )
                        : TweenAnimationBuilder<Duration>(
                            duration: const Duration(seconds: 30),
                            tween: Tween(
                                begin: const Duration(seconds: 30),
                                end: Duration.zero),
                            onEnd: () {
                              setState(() {
                                isVisible = true;
                              });
                            },
                            builder: (BuildContext context, Duration value,
                                Widget? child) {
                              final minutes = value.inMinutes;
                              final seconds = value.inSeconds % 60;
                              return Text('$minutes:$seconds',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.josefinSans(
                                      color: Colors.green,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 17.sp));
                            },
                          ),
                  ],
                ),
              ),
            ],
          )
        : Center(
            child: Image.asset('assets/images/loading.gif', height: 30.h),
          );
  }

  void verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${widget.phone}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null) {
            //--------------------------------------------------------------        Action for auto verification
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
        print("Blocked Number");
        Navigator.pop(context);
        alertdialog(
            context,
            "Some_Things_Went_Wrong_Please_Check_Mobile_Number_OR_Try_After_Some_Time"
                .tr());
      },
      codeSent: (String verificationID, int? resendToken) {
        setState(() {
          _verificationCode = verificationID;
          print("codeSent :- $verificationID");
        });
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        // setState(() {
        //   _verificationCode = verificationID;
        //   print("codeAutoRetrievalTimeout :- $_verificationCode");
        // });
      },
      // timeout: Duration(seconds: 05),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verifyPhone();
  }

  Future<String> uploadImage(File image) async {
    Reference db = FirebaseStorage.instance.ref("Users_pic/${widget.phone}");
    await db.putFile(image);

    return await db.getDownloadURL();
  }

  void otpdone(context, otpcontroller) async {
    bool isOnline = await hasNetwork();

    if (otpcontroller.text.trim().length == 6 && isOnline == true) {
      try {
        alertdialogText(context, "Please_wait..".tr());
        await FirebaseAuth.instance
            .signInWithCredential(PhoneAuthProvider.credential(
                verificationId: _verificationCode,
                smsCode: otpcontroller.text.trim()))
            .then((value) async {
          if (value.user != null) {
            if (widget.name.isEmpty) {
              fs
                  .collection("AllUsers")
                  .doc(widget.phone)
                  .update({"_password": otpcontroller.text.trim()});

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                  (route) => false);
            } else {
              if (widget.path.isNotEmpty) {
                url = await uploadImage(File(widget.path));
              }

              String uid = FirebaseAuth.instance.currentUser!.uid;

              await fs.collection('AllUsers').doc(widget.phone).set({
                '_uid': uid,
                '_phone': widget.phone,
                '_password': otpcontroller.text.trim(),
              });

              await fs.collection('UserDetails').doc(uid).set({
                "_uid": uid,
                "_name": widget.name,
                "_phone": widget.phone,
                "_image": url,
              });

              SharedPreferences.getInstance().then((value) {
                value.setString("UserId", uid);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false);
              });
            }
          }
        });
      } catch (e) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        alertdialog(context, "Please_Enter_Valid_OTP".tr());
      }
    } else {
      isOnline == false
          ? alertdialog(context, "Please_check_your_connection".tr())
          : alertdialog(context, "Please_Enter_Valid_OTP".tr());
    }
  }
}
