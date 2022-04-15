import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import '../style.dart';
import 'cart_screen.dart';

class Supportpage extends StatefulWidget {
  final VoidCallback openDrawer;
  const Supportpage({Key? key, required this.openDrawer}) : super(key: key);

  @override
  State<Supportpage> createState() => _SupportpageState();
}

class _SupportpageState extends State<Supportpage> {
  List<Widget> chips = [];
  List<int> chatList = [];
  ScrollController listScrollController = ScrollController();
  List<String> questions = [
    "",
    "Hello",
    "Good Morning",
    "I didn't get my order",
    "food are Missing",
    "I didn't get my refund",
    "Good Evening",
    "Bye",
    "Where’s my order?",
    "Is there any offer today?",
    "Delivery charge?",
    "Where’s your Restaurant?",
  ];
  List<String> answers = [
    "Hello, How i can help you",
    "Hey",
    "Good Morning",
    "You can contect on 1234567890",
    "Sorry for that, we will refund your money",
    "you will get, its take 2 to 5 days",
    "Good Evening",
    "Bye",
    "Your order is on the way",
    "For offers, You should check App",
    "Its depend on your location",
    "Anupam plaza, simada gam, surat"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatList.add(0);
    getdata();
  }

  void getdata() {
    for (int i = 1; i < questions.length; i++) {
      chips.add(
        InkWell(
          onTap: () {
            setState(() {
              chatList.add(i);
            });
          },
          child: Chip(
            elevation: 10,
            label: Text(
              questions[i],
              style:
                  GoogleFonts.josefinSans(fontSize: 13.sp, color: Colors.green),
            ),
            padding: EdgeInsets.all(8.w),
            backgroundColor: Colors.white,
            shadowColor: Colors.black,
          ),
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now();
    String formattedDate = DateFormat.MMMMEEEEd().format(date);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
            size: 30.sp,
          ),
          onPressed: widget.openDrawer,
        ),
        title: Center(
            child: Text(
          "Support".tr(),
          style: GoogleFonts.josefinSans(fontSize: 22.sp),
        )),
        backgroundColor: Colors.black,
        actions: [
          Container(
            padding: EdgeInsets.only(
              right: 15.w,
            ),
            child: Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 30.sp,
                  ),
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child:
                                Cartpage(() {}, type: "item_detail_screen")));
                    setState(() {
                      all_cart;
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.w, top: 3.h),
                  child: CircleAvatar(
                    radius: 9.r,
                    backgroundColor: Colors.lightGreen,
                    child: Text(
                      "$all_cart",
                      style: GoogleFonts.josefinSans(
                          fontSize: 12.sp, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 30.h),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100.w,
                          padding: EdgeInsets.only(top: 3.h),
                          child: Divider(
                            height: 10.h,
                            thickness: 1,
                            endIndent: 5.w,
                            color: Colors.black12,
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: GoogleFonts.josefinSans(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.65)),
                        ),
                        Container(
                          width: 100.w,
                          padding: EdgeInsets.only(top: 3.h),
                          child: Divider(
                            height: 10.h,
                            thickness: 1,
                            indent: 5.w,
                            color: Colors.black12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    //color: Colors.yellow,
                    margin:
                        EdgeInsets.only(left: 15.h, right: 15.h, bottom: 0.h),
                    height: 400.h,
                    child: ListView.builder(
                      itemCount: chatList.length,
                      controller: listScrollController,
                      itemBuilder: (BuildContext context, int index) {
                        return index != 0
                            ? Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(),
                                      Card(
                                        elevation: 7,
                                        child: Container(
                                          color: Colors.green,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.h, horizontal: 10.w),
                                          child: Text(
                                            questions[chatList[index]],
                                            style: GoogleFonts.josefinSans(
                                                fontSize: 14.sp,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 0,
                                    height: 5.h,
                                    color: Colors.transparent,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Card(
                                        elevation: 5,
                                        color: Colors.grey.shade100,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.h, horizontal: 10.w),
                                          child: Text(
                                            answers[chatList[index]],
                                            style: GoogleFonts.josefinSans(
                                                fontSize: 14.sp,
                                                color: Colors.green),
                                          ),
                                        ),
                                      ),
                                      Container(),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 0,
                                    height: 5.h,
                                    color: Colors.transparent,
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Card(
                                        elevation: 5,
                                        color: Colors.grey.shade100,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.h, horizontal: 10.w),
                                          child: Text(
                                            answers[chatList[index]],
                                            style: GoogleFonts.josefinSans(
                                                fontSize: 14.sp,
                                                color: Colors.green),
                                          ),
                                        ),
                                      ),
                                      Container(),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 0,
                                    height: 5.h,
                                    color: Colors.transparent,
                                  ),
                                ],
                              );
                      },
                    ),
                  ),
                  scrollfun(),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 10.w,
              right: 10.w,
            ),
            height: 130.h,
            width: double.infinity,
            // color: Colors.grey.shade200,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    offset: Offset(1, 1), blurRadius: 10, color: Colors.black)
              ],
              color: Colors.green.shade400,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 7.h),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10.w,
                  children: chips,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget scrollfun() {
    if (listScrollController.hasClients) {
      print("this is list position");
      final position = listScrollController.position.maxScrollExtent;
      listScrollController.animateTo(
        position + 110,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
    return const Center();
  }
}
