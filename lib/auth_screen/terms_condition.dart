import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class terms_condition extends StatelessWidget {
  const terms_condition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Term & Condition".tr(),
          style: GoogleFonts.josefinSans(),
        ),
      ),
      body: Center(
        child: Text(
          "This_is_Terms_and_Conditions".tr(),
          style: GoogleFonts.josefinSans(fontSize: 20.sp),
        ),
      ),
    );
  }
}
