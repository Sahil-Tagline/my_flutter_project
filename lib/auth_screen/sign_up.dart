import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:eat_it_ppsu/auth_screen/sign_in.dart';
import 'package:eat_it_ppsu/auth_screen/terms_condition.dart';
import 'package:eat_it_ppsu/images_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

import '../style.dart';
import 'otp.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String path = "";
  bool _inProcess = false;

  TextEditingController name1 = TextEditingController();
  TextEditingController phone1 = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_inProcess == true) {
          setState(() {
            _inProcess = false;
          });

          return true;
        }
        return true;
      },
      child: Stack(
        children: <Widget>[
          //----------------------------------------------------------------------------- background image
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: const AssetImage(images.home_food),
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
          _inProcess
              ? Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child:
                        Image.asset('assets/images/loading.gif', height: 30.h),
                  ),
                )
              : const Center(),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    bool _isUserExist;

    return Column(
      children: [
        //----------------------------------------------------------------------------- back button
        Container(
          margin: EdgeInsets.only(top: 40.h, left: 13.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
        //----------------------------------------------------------------------------- Profile pic
        Container(
          // margin: EdgeInsets.only(top: 110.h),
          margin: EdgeInsets.only(top: 43.h),
          child: Center(
            child: GestureDetector(
              onTap: () {
                _showDialog(context);
              },
              child: CircleAvatar(
                radius: 50.r,
                backgroundColor: const Color(0xff2b3230).withOpacity(0.8),
                backgroundImage: path.isNotEmpty ? FileImage(File(path)) : null,
                child: path.isEmpty
                    ? Icon(Icons.camera_alt,
                        size: 60.sp, color: Color(white_Color))
                    : null,
              ),
            ),
          ),
        ),
        //----------------------------------------------------------------------------- sign up body
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 30.h),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    width: 250.w,
                    height: 50.h,
                    // margin: EdgeInsets.only(top: 30.h),
                    child: TextField(
                      controller: name1,
                      cursorColor: Colors.white,
                      style: textfield,
                      maxLength: 18,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Name'.tr(),
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
                      style: textfield,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: phone1,
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
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
                      margin: EdgeInsets.only(top: 12.h),
                      child: Text(
                        "We_send_You_a_password_in_sms".tr(),
                        style: GoogleFonts.josefinSans(
                            fontSize: 15.sp, color: Color(white_Color)),
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 70.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const checkbox(),
                        Text(
                          "I_agree_with".tr(),
                          style: GoogleFonts.josefinSans(
                            color: Colors.white,
                            fontSize: 17.sp,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: const terms_condition())),
                          child: Text(
                            "Terms_&_Conditions".tr(),
                            style: GoogleFonts.josefinSans(
                                color: Colors.green,
                                fontSize: 17.sp,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 45.h,
                    width: 250.w,
                    margin: EdgeInsets.only(top: 101.5.h),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      child: Text(
                        "SIGN_UP".tr(),
                        style: GoogleFonts.montserrat(
                            fontSize: 20.sp, letterSpacing: 0.5.sp),
                      ),
                      onPressed: () async {
                        bool isOnline = await hasNetwork();
                        if (isOnline == true) {
                          if (phone1.text.isNotEmpty && name1.text.isNotEmpty) {
                            if ((phone1.text).length == 10) {
                              alertdialogText(context, "Please_wait...".tr());
                              _isUserExist =
                                  await isUserExist(phone1.text.trim());

                              if (_isUserExist == true) {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                                alertdialog(context, "User_Already_Exist".tr());
                              } else if (_isUserExist == false) {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: OtpVerification(
                                            phone: phone1.text.trim(),
                                            name: name1.text.trim(),
                                            path: path)));
                              }
                            } else {
                              alertdialog(context,
                                  "Length_of_Phone_No_should_be_10_digit".tr());
                            }
                          } else if (phone1.text.isEmpty ||
                              name1.text.isEmpty) {
                            alertdialog(context, "Please_Fill_all_Fields".tr());
                          }
                        } else {
                          alertdialog(
                              context, "Please_check_your_connection".tr());
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 35.h, bottom: 25.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "I_have".tr(),
                          style: GoogleFonts.josefinSans(
                            color: Colors.white,
                            fontSize: 17.sp,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  SignIn(),
                              transitionDuration: Duration.zero,
                            ),
                          ),
                          child: Text(
                            "an_account".tr(),
                            style: GoogleFonts.josefinSans(
                                color: Colors.green,
                                fontSize: 17.sp,
                                decoration: TextDecoration.underline),
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

  Future _showDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r)), //this right here
        content: Container(
          height: 150.h,
          width: 200.w,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                  child: Text(
                    "Select_Option".tr(),
                    style: GoogleFonts.josefinSans(
                        fontSize: 25.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    size: 40.sp,
                  ),
                  title: Text(
                    "Camera".tr(),
                    style: GoogleFonts.josefinSans(fontSize: 20.sp),
                  ),
                  onTap: () async {
                    ImageSelecter(ImageSource.camera);
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: Icon(
                    Icons.photo,
                    size: 40.sp,
                  ),
                  title: Text(
                    "Gallery".tr(),
                    style: GoogleFonts.josefinSans(fontSize: 20.sp),
                  ),
                  onTap: () async {
                    ImageSelecter(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void ImageSelecter(ImageSource source) async {
    //const String Image_Cropper = "Image_Cropper";

    Navigator.pop(context);
    setState(() {
      _inProcess = true;
    });
    final ImagePicker _picker = ImagePicker();
    final file = await _picker.pickImage(source: source);
    if (file != null) {
      final cropped = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 50,
        maxHeight: 700,
        maxWidth: 700,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarWidgetColor: Colors.white,
          toolbarColor: Colors.green,
          statusBarColor: Colors.green,
          toolbarTitle: "Image_Cropper".tr(),
          backgroundColor: Colors.white,
          activeControlsWidgetColor: Colors.green,
        ),
      );

      if (cropped != null) {
        setState(() {
          path = cropped.path;
          _inProcess = false;
        });
      }
    }
    setState(() {
      //print("in progress0");
      _inProcess = false;
    });
  }
}

class checkbox extends StatefulWidget {
  const checkbox({Key? key}) : super(key: key);

  @override
  _checkboxState createState() => _checkboxState();
}

class _checkboxState extends State<checkbox> {
  bool value = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 17.sp,
      child: Checkbox(
        fillColor: MaterialStateProperty.all(Colors.green),
        checkColor: Colors.white,
        activeColor: Colors.green,
        autofocus: true,
        value: value,
        onChanged: (bool? val) {
          setState(() {
            value = val!;
          });
        },
      ),
    );
  }
}
