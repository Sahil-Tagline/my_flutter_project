import 'package:easy_localization/src/public_ext.dart';
import 'package:eat_it_ppsu/drawer/home.dart';
import 'package:eat_it_ppsu/images_link.dart';
import 'package:eat_it_ppsu/services/notification_service.dart';
import 'package:eat_it_ppsu/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class CompleteOrderPage extends StatefulWidget {
  final double totalPrice;
  final DateTime dateTime;
  const CompleteOrderPage(
      {Key? key, required this.totalPrice, required this.dateTime})
      : super(key: key);

  @override
  State<CompleteOrderPage> createState() => _CompleteOrderPageState();
}

class _CompleteOrderPageState extends State<CompleteOrderPage> {
  DateTime time = DateTime.now();
  late String otime;
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.MMMd().format(time).replaceAll(" ", ", ");
    if (time.hour > 12) {
      int h = time.hour - 12;
      otime = "$h:${time.minute} PM";
    } else {
      int h = time.hour;
      otime = "$h:${time.minute} AM";
    }

    return WillPopScope(
      onWillPop: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade, child: const HomePage()));
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 23.sp,
              ),
              onPressed: () => Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade, child: const HomePage())),
            ),
          ),
          title: Center(
              child: Text(
            "Order_Completed".tr(),
            style: GoogleFonts.josefinSans(fontSize: 22.sp),
          )),
          backgroundColor: Colors.black,
          actions: [
            Icon(
              Icons.local_grocery_store_outlined,
              color: Colors.black,
              size: 50.sp,
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(images.home_food),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.7), BlendMode.srcOver),
              )),
            ),
            Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 70.h),
                    child: Center(
                        child: Text(
                      "$formattedDate at ${otime}",
                      style: GoogleFonts.josefinSans(
                          fontSize: 16.sp, color: Colors.white),
                    )),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total".tr(),
                          style: GoogleFonts.josefinSans(
                              fontSize: 16.sp, color: Colors.white),
                        ),
                        Text(
                          "\$${widget.totalPrice}",
                          style: GoogleFonts.josefinSans(
                              fontSize: 16.sp, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 70.h),
                    height: 250.h,
                    width: 270.w,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 50.h),
                              child: Text(
                                "How_was_your_order".tr(),
                                style: GoogleFonts.josefinSans(
                                    fontSize: 18.sp,
                                    color: Colors.black.withOpacity(0.6),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 7.h),
                              child: Text(
                                "experience_from_Eat_it".tr(),
                                style: GoogleFonts.josefinSans(
                                    fontSize: 18.sp,
                                    color: Colors.black.withOpacity(0.6),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 35.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _ratingStar(context, 0),
                                  _ratingStar(context, 1),
                                  _ratingStar(context, 2),
                                  _ratingStar(context, 3),
                                  _ratingStar(context, 4),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                _sendNotification(context);
                              },
                              child: Container(
                                height: 50.h,
                                width: 135.w,
                                color: Colors.grey.shade300,
                                child: Center(
                                  child: Text(
                                    "MAYBE_LATER".tr(),
                                    style: GoogleFonts.josefinSans(
                                        fontSize: 13.sp,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5.w),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (rating > 0) {
                                  _sendNotification(context);
                                } else {
                                  snackbar(
                                      context, "Please_give_the_rating".tr());
                                }
                              },
                              child: Container(
                                height: 50.h,
                                width: 135.w,
                                color: Colors.green,
                                child: Center(
                                  child: Text(
                                    "SUBMIT".tr(),
                                    style: GoogleFonts.josefinSans(
                                        fontSize: 13.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5.w),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ratingStar(BuildContext context, int i) {
    return rating > i
        ? InkWell(
            onTap: () {
              setState(() {
                rating = i + 1;
              });
            },
            child: Icon(
              Icons.star,
              color: Colors.green,
              size: 30.sp,
            ))
        : InkWell(
            onTap: () {
              setState(() {
                rating = i + 1;
              });
            },
            child: Icon(
              Icons.star_border_rounded,
              color: Colors.black45,
              size: 30.sp,
            ));
  }

  void _sendNotification(BuildContext context) {
    if (notificationStatus) {
      try {
        NotificationService.showNotification(
          title: all_user,
          body: 'Your_order_is_Completed_Enjoy_your_meal_Thank_You'.tr(),
          payload: all_user,
        );
      } catch (e) {
        print("notification Error : $e");
      }
    }

    Navigator.push(context,
        PageTransition(type: PageTransitionType.fade, child: const HomePage()));
  }
}
