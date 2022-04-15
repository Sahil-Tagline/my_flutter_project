import 'package:easy_localization/src/public_ext.dart';
import 'package:eat_it_ppsu/images_link.dart';
import 'package:eat_it_ppsu/main.dart';
import 'package:eat_it_ppsu/models/hive_model.dart';
import 'package:eat_it_ppsu/screen/Complete_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import '../style.dart';
import 'checkout_screen.dart';

class Cartpage extends StatefulWidget {
  final VoidCallback openDrawer;
  String type;
  Cartpage(this.openDrawer, {Key? key, required this.type}) : super(key: key);

  @override
  State<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {
  bool edit = false;
  int count = 0;
  late List<bool> selected;
  late List<ItemsData> list;
  double totalprice = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<ItemsData> data = box.values
        .where((element) => element.itemCount > 0)
        .cast<ItemsData>()
        .toList();

    data.forEach((element) {
      totalprice += element.price * element.itemCount;
    });
    // DateTime now = new DateTime.now();
    // print("Current date : $now");
    // print("Current date : ${now.year}");
    // DateTime date = new DateTime(now.year, now.month, now.day);
    // print("date : $date");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.type == "home"
            ? IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 30.sp,
                ),
                onPressed: widget.openDrawer,
              )
            : Padding(
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
          child: Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Text(
              "Cart".tr(),
              style: GoogleFonts.josefinSans(fontSize: 22.sp),
            ),
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          InkWell(
            onTap: () {
              if (edit) {
                setState(() {
                  edit = false;
                });
              } else {
                setState(() {
                  edit = true;
                });
              }
            },
            child: Center(
                child: Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Text(
                edit ? "Cancel".tr() : "Edit".tr(),
                style: GoogleFonts.josefinSans(fontSize: 22.sp),
              ),
            )),
          ),
        ],
      ),
      //drawer: DrawerScreen(),

      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              width: double.infinity,
              padding: EdgeInsets.only(
                  top: 10.h, bottom: 10.h, left: 10.w, right: 10.w),
              child: ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder: (BuildContext context, Box<dynamic> items, _) {
                  List<ItemsData> datalist = items.values
                      .where((element) => element.itemCount > 0)
                      .cast<ItemsData>()
                      .toList();

                  list = datalist;
                  !edit
                      ? selected = List<bool>.generate(
                          datalist.length, (index) => false,
                          growable: true)
                      : selected;
                  return datalist.length > 0
                      ? ListView.separated(
                          itemCount: datalist.length,
                          separatorBuilder: (_, index) => Divider(
                                thickness: 0,
                                height: 7.h,
                              ),
                          itemBuilder: (_, index) {
                            final ItemsData data = datalist[index];
                            return Container(
                              height: 110.h,
                              child: Card(
                                elevation: 10,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 110.h,
                                      width: 110.h,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                        image: NetworkImage(data.url),
                                        fit: BoxFit.cover,
                                      )),
                                    ),
                                    Container(
                                      height: 110.h,
                                      width: 199.w,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 20.w,
                                                    top: 15.h,
                                                    right: 30.w),
                                                child: Text(
                                                  capitalize(data.name),
                                                  style:
                                                      GoogleFonts.josefinSans(
                                                    fontSize: 17.sp,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              edit
                                                  ? SizedBox(
                                                      height: 30.h,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 185.w,
                                                                top: 10.h),
                                                        child: Transform.scale(
                                                          scale: 1.2,
                                                          child: Checkbox(
                                                            value:
                                                                selected[index],
                                                            fillColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .red),
                                                            onChanged: (val) {
                                                              setState(() {
                                                                if (val!) {
                                                                  count++;
                                                                } else {
                                                                  count--;
                                                                }
                                                                selected[
                                                                        index] =
                                                                    val;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : const Center(),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 20.w,
                                                top: 5.h,
                                                right: 10.w),
                                            child: Text(
                                              capitalize(data.category),
                                              style: GoogleFonts.josefinSans(
                                                  fontSize: 15.sp,
                                                  letterSpacing: 1),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 20.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text.rich(TextSpan(
                                                    text: "\$${data.price}",
                                                    style:
                                                        GoogleFonts.josefinSans(
                                                            fontSize: 18.sp,
                                                            color: Colors.green,
                                                            letterSpacing: 0),
                                                    children: <InlineSpan>[
                                                      TextSpan(
                                                        text: data.itemCount > 1
                                                            ? ' x '
                                                            : '',
                                                        style: GoogleFonts
                                                            .josefinSans(
                                                                fontSize: 14.sp,
                                                                color: Colors
                                                                    .black54),
                                                      ),
                                                      TextSpan(
                                                        text: data.itemCount > 1
                                                            ? data.itemCount
                                                                .toString()
                                                            : '',
                                                        style: GoogleFonts
                                                            .josefinSans(
                                                                fontSize: 18.sp,
                                                                color: Colors
                                                                    .black54),
                                                      )
                                                    ])),
                                                !edit
                                                    ? Container(
                                                        height: 35.h,
                                                        width: 70.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.green,
                                                          shape: BoxShape
                                                              .rectangle,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5.r)),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                if (data.itemCount ==
                                                                    1) {
                                                                  all_cart -= 1;
                                                                }
                                                                setState(() {
                                                                  data.itemCount -=
                                                                      1;
                                                                  totalprice -=
                                                                      data.price;
                                                                  data.save();
                                                                });
                                                              },
                                                              child: Container(
                                                                height: 35.h,
                                                                width: 35.w,
                                                                child:
                                                                    const Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .remove,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            VerticalDivider(
                                                              width: 0.w,
                                                              thickness: 1,
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  data.itemCount ==
                                                                          10
                                                                      ? snackbar(
                                                                          context,
                                                                          'Max limit for this item is 10.\n So you can\'t add more time.')
                                                                      : data.itemCount +=
                                                                          1;
                                                                  totalprice +=
                                                                      data.price;
                                                                  data.save();
                                                                });
                                                              },
                                                              child: Container(
                                                                height: 35.h,
                                                                width: 35.w,
                                                                child:
                                                                    const Center(
                                                                  child: Icon(
                                                                    Icons.add,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : SizedBox(
                                                        height: 35.h,
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
                          })
                      : Center(
                          child: Stack(
                            children: [
                              Image.asset(images.cart_empty),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 190.h, left: 150.w),
                                child: Text(
                                  'Empty',
                                  style: GoogleFonts.josefinSans(
                                      color: Colors.green, fontSize: 20.sp),
                                ),
                              )
                            ],
                          ),
                        );
                },
              ),
            ),
          ),
          !edit
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  height: 50.h,
                  width: double.infinity,
                  color: Colors.green,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (list.isNotEmpty) {
                            await Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: Checkout(
                                        orderdone: orderDone,
                                        totalPrice: totalprice)));
                          } else {
                            snackbar(context, "Cart_is_Empty".tr());
                          }
                        },
                        child: Text(
                          "BUY".tr(),
                          style: GoogleFonts.josefinSans(
                              fontSize: 20.sp, color: Colors.white),
                        ),
                      ),
                      Text(
                        "\$ $totalprice",
                        style: GoogleFonts.josefinSans(
                            fontSize: 20.sp, color: Colors.white),
                      )
                    ],
                  ),
                )
              : InkWell(
                  onTap: () {
                    for (int i = 0; i < selected.length; i++) {
                      if (selected[i]) {
                        totalprice -= list[i].price * list[i].itemCount;
                        list[i].itemCount = 0;
                        all_cart -= 1;
                      } else {
                        continue;
                      }
                    }
                    setState(() {
                      edit = false;
                      count = 0;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    height: 50.h,
                    width: double.infinity,
                    color: Colors.red,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "REMOVE".tr(),
                            style: GoogleFonts.josefinSans(
                                fontSize: 18.sp, color: Colors.white),
                          ),
                          Text(
                            "$count",
                            style: GoogleFonts.josefinSans(
                                fontSize: 18.sp, color: Colors.white),
                          ),
                          Text(
                            "ITEMS".tr(),
                            style: GoogleFonts.josefinSans(
                                fontSize: 18.sp, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void orderDone() {
    if (totalprice > 0) {
      DateTime time = DateTime.now();
      for (int i = 0; i < list.length; i++) {
        DateTime time = DateTime.now();
        //DateTime endTime= time.subtract(Duration(days:1));
        var formatter = DateFormat('yyyy-MM-dd');
        String date = formatter.format(time);

        if (i == 0) {
          fs
              .collection("Orders")
              .doc(all_uid)
              .collection("orders")
              .doc(date)
              .set({"_time": time});
        }
        fs
            .collection("Orders")
            .doc(all_uid)
            .collection("orders")
            .doc(date)
            .collection("orders")
            .doc(time.toString())
            .set({
          "_url": list[i].url,
          "_name": list[i].name,
          "_detail": list[i].detail,
          "_price": list[i].price,
          "_itemcount": list[i].itemCount,
          "_category": list[i].category,
          "_time": time,
        }).then(
          (value) => print("status $i done"),
        );
      }

      for (int i = 0; i < list.length; i++) {
        list[i].itemCount = 0;
        list[i].save();
      }

      // NotificationService.showNotification(
      //   title: all_user,
      //   body: 'Your order is Completed.\nEnjoy your meal, Thank You.',
      //   payload: all_user,
      // );

      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child:
                  CompleteOrderPage(totalPrice: totalprice, dateTime: time)));
      setState(() {
        all_cart = 0;
        totalprice = 0;
      });
    }
  }
}
