import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:eat_it_ppsu/images_link.dart';
import 'package:eat_it_ppsu/main.dart';
import 'package:eat_it_ppsu/models/hive_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../style.dart';
import 'cart_screen.dart';

class ItemDetailpage extends StatefulWidget {
  QueryDocumentSnapshot<Map<String, dynamic>> data;
  String category;
  ItemDetailpage(this.data, this.category, {Key? key}) : super(key: key);

  @override
  _ItemDetailpageState createState() => _ItemDetailpageState();
}

class _ItemDetailpageState extends State<ItemDetailpage> {
  late ItemsData hivedata;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() {
    try {
      hivedata = box.get(widget.data.get("_name"));
      hivedata.url = widget.data.get("_url");
      hivedata.detail = widget.data.get("_detail");
      if (int.parse(widget.data.get("_offer")) > 0) {
        hivedata.price = (double.parse(widget.data.get("_price")) *
            double.parse(widget.data.get("_offer")) /
            100);
      } else {
        hivedata.price = double.parse(widget.data.get("_price"));
      }
      hivedata.save();
    } catch (e) {
      print("this is catch");
      print("errro : $e");
      hivedata = ItemsData(
          name: widget.data.get("_name"),
          url: widget.data.get("_url"),
          detail: widget.data.get("_detail"),
          price: int.parse(widget.data.get("_offer")) > 0
              ? (double.parse(widget.data.get("_price")) *
                  double.parse(widget.data.get("_offer")) /
                  100)
              : double.parse(widget.data.get("_price")),
          favourite: false,
          itemCount: 0,
          category: widget.category);
      box.put(widget.data.get("_name"), hivedata);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.3, 0.9],
                colors: [
                  Colors.black.withOpacity(1),
                  Colors.black.withOpacity(0)
                ],
                tileMode: TileMode.repeated,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 23.sp,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: Center(
              child: Text(
            capitalize(widget.data.get("_name")),
            style: GoogleFonts.josefinSans(fontSize: 22.sp),
          )),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    Center(
                        child: Image.asset('assets/images/loading.gif',
                            height: 30.h)),
                    Container(
                      //height: 313.h,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: NetworkImage(widget.data.get("_url")),
                        fit: BoxFit.cover,
                      )),
                      child: style(
                          context,
                          widget.data.get("_detail"),
                          hivedata.itemCount > 1
                              ? double.parse(widget.data.get("_price")) *
                                  hivedata.itemCount
                              : double.parse(widget.data.get("_price"))),
                    ),
                  ],
                ),
              ),
            ),
            AddFavCart(hivedata, ontap: () {
              setState(() {});
            }),
            Comments(widget.data.get("_name")),
          ],
        ),
      ),
    );
  }
}

//---------------------------------------------------------------------------------------------------------- ADD favorite or cart button
class AddFavCart extends StatefulWidget {
  var hivedata;
  VoidCallback ontap;
  AddFavCart(this.hivedata, {Key? key, required this.ontap}) : super(key: key);

  @override
  _AddFavCartState createState() => _AddFavCartState();
}

class _AddFavCartState extends State<AddFavCart> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            if (widget.hivedata.favourite) {
              setState(() {
                widget.hivedata.favourite = false;
                widget.hivedata.save();
              });
            } else {
              setState(() {
                widget.hivedata.favourite = true;
                widget.hivedata.save();
              });
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: 50.h,
            color: Colors.grey.shade300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                !widget.hivedata.favourite
                    ? const Icon(
                        Icons.star_border_rounded,
                        color: Colors.black54,
                      )
                    : const Icon(
                        Icons.star,
                        color: Colors.orange,
                      ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    !widget.hivedata.favourite
                        ? "ADD_TO_FAVOURITE".tr()
                        : "FAVOURITE".tr(),
                    style: GoogleFonts.josefinSans(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            if (widget.hivedata.itemCount == 0) {
              setState(() {
                all_cart += 1;
                widget.ontap();
                widget.hivedata.itemCount += 1;
                widget.hivedata.save();
              });
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: 50.h,
            color: Colors.green,
            child: widget.hivedata.itemCount == 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.black54,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          "ADD_TO_CART".tr(),
                          style: GoogleFonts.josefinSans(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          if (widget.hivedata.itemCount == 1) {
                            all_cart -= 1;
                            widget.ontap();
                          }
                          setState(() {
                            widget.ontap();
                            widget.hivedata.itemCount -= 1;
                            widget.hivedata.save();
                          });
                          // box.put(widget.hivedata.key, widget.hivedata);
                        },
                        child: SizedBox(
                          height: 50.h,
                          width: 60.w,
                          child: Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 30.sp,
                          ),
                        ),
                      ),
                      Container(
                        height: 50.h,
                        width: 60.w,
                        color: Colors.black12.withOpacity(0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "x ",
                              style: GoogleFonts.josefinSans(
                                  fontSize: 13.sp, color: Colors.white),
                            ),
                            Text(
                              widget.hivedata.itemCount.toString(),
                              style: GoogleFonts.josefinSans(
                                  fontSize: 18.sp, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            widget.ontap();
                            widget.hivedata.itemCount == 10
                                ? snackbar(context,
                                    'Max limit for this item is 10.\n So you can\'t add more time.')
                                : widget.hivedata.itemCount += 1;
                            widget.hivedata.save();
                          });
                        },
                        child: SizedBox(
                          height: 50.h,
                          width: 60.w,
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 30.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

//---------------------------------------------------------------------------------------------------------- ADD favorite or cart button
class Comments extends StatefulWidget {
  String itemName;
  Comments(this.itemName, {Key? key}) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController messageControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: fs
              .collection("Comments")
              .doc(widget.itemName)
              .collection("comment")
              .orderBy("_time", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 14.h, horizontal: 25.w),
                      child: Text(
                        "Comments (${snapshot.data?.docs.length})",
                        style: GoogleFonts.josefinSans(fontSize: 20.sp),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 7.w, right: 20.sp),
                      height: 200.h,
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 35.h),
                              width: 150.w,
                              height: 80.h,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage(images.no_message),
                                fit: BoxFit.fill,
                              )),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              child: Text(
                                "No_Comments".tr(),
                                style: GoogleFonts.josefinSans(fontSize: 15.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 14.h, horizontal: 25.w),
                    child: Text(
                      "Comments (${snapshot.data?.docs.length})",
                      style: GoogleFonts.josefinSans(fontSize: 20.sp),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.w, right: 20.w),
                    height: 200.h,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.only(left: 0.0),
                              leading: CircleAvatar(
                                radius: 25.r,
                                backgroundColor:
                                    Color(0xff2b3230).withOpacity(0.8),
                                backgroundImage:
                                    AssetImage(images.defalt_pro_pic),
                                child: CircleAvatar(
                                  radius: 25.r,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: all_url.isNotEmpty
                                      ? NetworkImage(snapshot.data?.docs[index]
                                          .get("_url"))
                                      : null,
                                ),
                              ),
                              title: Padding(
                                padding: EdgeInsets.only(bottom: 5.h),
                                child: Text(
                                  snapshot.data?.docs[index].get("_name"),
                                  style: GoogleFonts.josefinSans(
                                      fontSize: 19.sp, color: Colors.green),
                                ),
                              ),
                              subtitle: Text(
                                snapshot.data?.docs[index].get("_comment"),
                                style: GoogleFonts.josefinSans(
                                    fontSize: 15.sp, height: 1.h),
                              ),
                            ),
                            Divider(
                              thickness: 0.9,
                              indent: 80.w,
                              endIndent: 0.w,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (!snapshot.hasData) {
              return Container(
                  height: 250.h,
                  child: Center(
                      child: Image.asset('assets/images/loading.gif',
                          height: 30.h)));
            } else if (snapshot.hasError) {
              return Container(
                height: 250.h,
                child: Center(child: Text(snapshot.error.toString())),
              );
            } else {
              return Container();
            }
          },
        ),
        Container(
          height: 50.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Padding(
              //   padding: EdgeInsets.only(
              //       top: 12.h, bottom: 12.h, left: 15.w, right: 5.h),
              //   child: Icon(
              //     Icons.camera_alt,
              //     color: Colors.black54,
              //     size: 28.sp,
              //   ),
              // ),
              // VerticalDivider(
              //   indent: 10,
              //   endIndent: 10,
              //   thickness: 1.w,
              // ),
              Container(
                width: 208.w,
                child: TextField(
                  controller: messageControler,
                  keyboardType: TextInputType.multiline,
                  cursorColor: Colors.grey.shade800,
                  style: GoogleFonts.josefinSans(
                      color: Colors.black54, fontSize: 15.sp),
                  decoration: InputDecoration(
                      fillColor: Colors.green,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: 'Your_messages'.tr()),
                ),
              ),
              InkWell(
                onTap: () {
                  if (messageControler.text.isNotEmpty) {
                    SendMessage(messageControler.text);
                  }
                },
                child: Container(
                  width: 88.w,
                  color: Colors.green,
                  child: Center(
                    child: Text("SEND".tr(),
                        style: GoogleFonts.josefinSans(
                            fontSize: 15.sp, color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void SendMessage(String message) async {
    bool isOnline = await hasNetwork();
    if (isOnline) {
      try {
        String datetime = DateTime.now().toString();
        await fs
            .collection("Comments")
            .doc(widget.itemName)
            .collection("comment")
            .add(
          {
            "_name": all_user,
            "_url": all_url,
            "_comment": message,
            "_time": datetime,
          },
        );
        setState(() {
          messageControler.text = "";
        });
      } catch (e) {
        alertdialog(context, e.toString());
      }
    } else {
      alertdialog(context, "Please_check_your_connection".tr());
    }
  }
}

style(BuildContext context, String detail, double price) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(),
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.black.withOpacity(.7), Colors.black.withOpacity(0)],
          stops: const [0.5, 1],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          tileMode: TileMode.repeated,
        )),
        padding: EdgeInsets.only(right: 15.w, left: 15.w, bottom: 5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Text(
                capitalize(detail),
                style:
                    GoogleFonts.josefinSans(fontSize: 15, color: Colors.white),
                //overflow: TextOverflow.ellipsis,
                //maxLines: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10.h, top: 5.h),
              child: Container(
                child: Text(
                  "\$${price.toStringAsFixed(2)}",
                  style: GoogleFonts.josefinSans(
                      fontSize: 25, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
