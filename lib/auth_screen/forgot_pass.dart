import 'package:easy_localization/src/public_ext.dart';
import 'package:eat_it_ppsu/images_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../style.dart';
import 'otp.dart';

// ignore: must_be_immutable
class ForgotPass extends StatelessWidget {
  ForgotPass({Key? key}) : super(key: key);

  bool? _isUserExist;
  TextEditingController phone1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          //----------------------------------------------------------------------------- background image
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: const AssetImage(images.home_food),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6), BlendMode.srcOver),
            )),
          ),
          Center(
              child: _body(
                  context)), //------------------------------------------------------------ body
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
                    padding: const EdgeInsets.only(top: 5.0),
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
    return Column(
      children: [
        //----------------------------------------------------------------------------- title
        Padding(
          padding: EdgeInsets.only(top: 130.h),
          child: Text(
            "FORGOT_PASSWORD".tr(),
            style:
                GoogleFonts.josefinSans(color: Colors.green, fontSize: 30.sp),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5.sp),
          child: Text(
            "We_send_You_a_password_in_sms".tr(),
            style:
                GoogleFonts.josefinSans(color: Colors.white, fontSize: 17.sp),
          ),
        ),
        //----------------------------------------------------------------------------- otp body
        Container(
          width: 250.w,
          height: 50.h,
          margin: EdgeInsets.only(top: 30.h),
          child: TextField(
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            cursorColor: Colors.white,
            controller: phone1,
            autofocus: true,
            style: textfield,
            maxLength: 10,
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
            onSubmitted: (String value) => fdone(context, phone1, _isUserExist),
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
            onPressed: () => fdone(context, phone1, _isUserExist),
          ),
        ),
      ],
    );
  }

  void fdone(context, phone1, _isUserExist) async {
    bool isOnline = await hasNetwork();

    if (isOnline == true) {
      if (phone1.text.isNotEmpty && phone1.text.trim().length == 10) {
        alertdialogText(context, "Please_wait...".tr());
        _isUserExist = await isUserExist(phone1.text.trim());
        if (_isUserExist == true) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: OtpVerification(
                      phone: phone1.text.trim(), name: "", path: "")));
        } else {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          alertdialog(context,
              "User_Not_Exist_With_This_Number!_Please_Sign_Up_First".tr());
        }
      } else {
        alertdialog(context, "Please_Enter_Valid_Phone_No".tr());
      }
    } else {
      alertdialog(context, "Please_check_your_connection".tr());
    }
  }
}
