import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:eat_it_ppsu/images_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../style.dart';

class Settingpage extends StatefulWidget {
  final VoidCallback openDrawer;
  const Settingpage({Key? key, required this.openDrawer}) : super(key: key);

  @override
  State<Settingpage> createState() => _SettingpageState();
}

class _SettingpageState extends State<Settingpage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController address = TextEditingController();

    return Scaffold(
        resizeToAvoidBottomInset: false,
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
            "Settings".tr(),
            style: GoogleFonts.josefinSans(fontSize: 22.sp),
          )),
          backgroundColor: Colors.black,
          actions: [
            Icon(
              Icons.local_grocery_store_outlined,
              color: Colors.black,
              size: 40.sp,
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              //background image
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(images.home_food),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.6), BlendMode.srcOver),
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30.h, bottom: 30.h, left: 30.w),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 45.r,
                        backgroundImage:
                            const AssetImage(images.defalt_pro_pic),
                        child: CircleAvatar(
                          radius: 45.r,
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              all_url.isNotEmpty ? NetworkImage(all_url) : null,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 13.w),
                        child: Text(
                          all_user,
                          style: GoogleFonts.josefinSans(
                              color: Colors.white, fontSize: 22.sp),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey.shade200,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 25.w, right: 25.w),
                          //color: Colors.white,
                          height: 60.h,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Push_notification".tr(),
                                style: GoogleFonts.josefinSans(
                                    fontSize: 18.sp,
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.7.w),
                              ),
                              FlutterSwitch(
                                width: 60.w,
                                height: 30.h,
                                toggleSize: 30.sp,
                                borderRadius: 30.r,
                                padding: 1.5.w,
                                activeColor: Colors.green,
                                value: notificationStatus,
                                onToggle: (bool value) async {
                                  setState(() {
                                    notificationStatus = value;
                                  });
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool(
                                      'NotificationStatus', notificationStatus);
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 50.h,
                          width: double.infinity,
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              "My_Addresses".tr(),
                              style: GoogleFonts.josefinSans(
                                  fontSize: 18,
                                  color: Colors.black.withOpacity(0.6),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                            child: StreamBuilder<QuerySnapshot>(
                                stream: fs
                                    .collection("UserDetails")
                                    .doc(all_uid)
                                    .collection("address")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data!.docs.isNotEmpty) {
                                      return ListView.builder(
                                        itemCount: snapshot.data!.size,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 5.h),
                                            child: Card(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15.w,
                                                    vertical: 10.h),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 5.h),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Address".tr(),
                                                            style: GoogleFonts
                                                                .josefinSans(
                                                                    fontSize:
                                                                        14.sp,
                                                                    color: Colors
                                                                        .green,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    letterSpacing:
                                                                        0.6.w),
                                                          ),
                                                          Text(
                                                            " ${index + 1}",
                                                            style: GoogleFonts
                                                                .josefinSans(
                                                                    fontSize:
                                                                        14.sp,
                                                                    color: Colors
                                                                        .green,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    letterSpacing:
                                                                        0.6.w),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                        snapshot
                                                            .data!.docs[index]
                                                            .get("_address"),
                                                        style: GoogleFonts
                                                            .josefinSans(
                                                                fontSize: 17.sp,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.6),
                                                                letterSpacing:
                                                                    0.5.w)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      return Center(
                                        child: Text(
                                          'Empty',
                                          style: GoogleFonts.josefinSans(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontSize: 20.sp),
                                        ),
                                      );
                                    }
                                  } else if (!snapshot.hasData) {
                                    return Center(
                                        child: Center(
                                            child: Image.asset(
                                                'assets/images/loading.gif',
                                                height: 30.h)));
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Center(
                                          child: Text(
                                        snapshot.error.toString(),
                                        style: GoogleFonts.josefinSans(),
                                      )),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 55.h,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      child: Text(
                        "ADD_ADDRESS".tr(),
                        style: GoogleFonts.montserrat(
                            fontSize: 16.sp, letterSpacing: 0.5.sp),
                      ),
                      onPressed: () {
                        showDialog<String>(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            content: TextFormField(
                              maxLines: null,
                              maxLength: 100,
                              controller: address,
                              keyboardType: TextInputType.multiline,
                              textCapitalization: TextCapitalization.words,
                            ),
                            actions: <Widget>[
                              Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 80.w,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (address.text.isNotEmpty) {
                                            bool isOnline = await hasNetwork();
                                            if (isOnline) {
                                              try {
                                                alertdialogText(context,
                                                    "Please_wait...".tr());
                                                await fs
                                                    .collection("UserDetails")
                                                    .doc(all_uid)
                                                    .collection("address")
                                                    .add({
                                                  "_address": address.text
                                                });
                                                print("done");
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              } catch (e) {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                alertdialog(
                                                    context, e.toString());
                                              }
                                            } else {
                                              alertdialog(
                                                  context,
                                                  "Please_check_your_connection"
                                                      .tr());
                                            }
                                          }
                                        },
                                        child: Text(
                                          "ADD".tr(),
                                          style: GoogleFonts.josefinSans(
                                              fontSize: 12.sp,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 80.w,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.grey.shade300),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "CANCEL".tr(),
                                          style: GoogleFonts.josefinSans(
                                              fontSize: 12.sp,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
          ],
        ));
  }
}
