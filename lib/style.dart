import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

String all_user = "User Name";
String all_url = "";
String all_uid = "";
int all_cart = 0;
int all_fav = 0;
int all_offer = 0;
late bool notificationStatus;

final fs = FirebaseFirestore.instance;

String capitalize(String s) =>
    s[0].toUpperCase() + s.substring(1).toLowerCase();

var text_style = GoogleFonts.josefinSans(
  textStyle: TextStyle(
    color: Colors.white,
    letterSpacing: 0.6.w,
    height: 1.2.h,
    fontSize: 20.sp,
  ),
);

var textfield = GoogleFonts.josefinSans(
  color: Colors.white,
  fontSize: 20.sp,
);

var white_Color = 0xfff5f5f5;

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackbar(
    context, String msg) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.green,
        onPressed: () {
          // Code to execute.
        },
      ),
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: GoogleFonts.josefinSans(color: Colors.green),
      ),
      duration: const Duration(milliseconds: 2000),
      width: 280.0, // Width of the SnackBar.
      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0.sp),
      ),
    ),
  );
}

Future<bool> hasNetwork() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}

alertdialog(context, String msg) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      // title: const Text('Error'),
      content: Text(msg,
          textAlign: TextAlign.center, style: GoogleFonts.josefinSans()),
      actions: <Widget>[
        Center(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: GoogleFonts.josefinSans(),
            ),
          ),
        ),
      ],
    ),
  );
}

alertdialogText(context, String msg) {
  return showDialog<String>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => AlertDialog(
      content: Text(
        msg,
        style: GoogleFonts.josefinSans(),
      ),
    ),
  );
}

Future<bool> isUserExist(String phone) async {
  final value = await fs.collection("AllUsers").doc(phone).get();
  if (value.exists) {
    print("fs User exists");
    return true;
  }
  return false;
}

String isSelected = "Menu";

class createDrawerBodyItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final ValueChanged<String> onSelectedItem;
  createDrawerBodyItem(
      {Key? key,
      required this.icon,
      required this.title,
      required this.onSelectedItem})
      : super(key: key);

  @override
  State<createDrawerBodyItem> createState() => _createDrawerBodyItemState();
}

class _createDrawerBodyItemState extends State<createDrawerBodyItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor:
          isSelected == widget.title ? Colors.black.withOpacity(0.7) : null,
      onTap: () {
        print("${widget.title}");
        if (widget.title == "Log Out") {
          isSelected = "Menu";
        } else {
          isSelected = widget.title;
        }
        widget.onSelectedItem(widget.title);
      },
      horizontalTitleGap: 10.w,
      leading: Icon(
        widget.icon,
        color: Colors.white,
        size: 30.sp,
      ),
      title: Text(
        widget.title,
        style: GoogleFonts.josefinSans(color: Colors.white, fontSize: 20.sp),
      ),
      trailing: widget.title == "My Cart" || widget.title == "Offers"
          ? CircleAvatar(
              radius: 15.r,
              backgroundColor: Colors.lightGreen,
              child: Text(
                widget.title == "My Cart" ? "$all_cart" : "$all_offer",
                style: GoogleFonts.josefinSans(
                    fontSize: 15.sp, color: Colors.white),
              ),
            )
          : null,
      style: ListTileStyle.drawer,
    );
  }
}

void logout(BuildContext context) async {
  bool isOnline = await hasNetwork();
  if (isOnline == true) {
    GoogleSignIn _googleSignIn = GoogleSignIn();

    final prefs = await SharedPreferences.getInstance();
    print("home : ${prefs.getInt('islogedin')}");
    await prefs.setInt('islogedin', 0);
    prefs.remove("UserId");
    prefs.remove("UserName");
    prefs.remove("Url");
    print("home1 : ${prefs.getInt('islogedin')}");

    bool googleSignin = await _googleSignIn.isSignedIn();
    if (googleSignin) {
      print("Google Sign Out Done");
      _googleSignIn.signOut().then((value) {}).catchError((e) {});
    }

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
        (route) => false);
  }
}

bool checkType(String type) {
  try {
    int phone = int.parse(type);
    print("phone : $phone");
    return true;
  } catch (e) {
    print("email : $e");
    return false;
  }
}

// void struct(context) async {
//   bool isOnline = await hasNetwork();
//   if(isOnline){
//     try{
//       alertdialogText(context, "Please Wait...");
//
//     }catch (e) {
//       Navigator.pop(context);
//       alertdialog(context, e.toString());
//     }
//   }else{
//     alertdialog(context, "Please check your Connection");
//   }
// }
