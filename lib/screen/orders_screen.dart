import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:eat_it_ppsu/images_link.dart';
import 'package:eat_it_ppsu/models/hive_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import '../main.dart';
import '../style.dart';
import 'cart_screen.dart';

class Orderspage extends StatefulWidget {
  final VoidCallback openDrawer;
  const Orderspage({Key? key, required this.openDrawer}) : super(key: key);

  @override
  State<Orderspage> createState() => _OrderspageState();
}

class _OrderspageState extends State<Orderspage> with TickerProviderStateMixin {
  List<String> dateList = [];
  var data;
  bool nodata = false;
  late List<Tab> _tabs = <Tab>[];
  late List<Widget> _children = <Widget>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    DateTime currentDate = DateTime.now();
    DateTime endDate = currentDate.subtract(const Duration(days: 6));
    data = await fs
        .collection("Orders")
        .doc(all_uid)
        .collection("orders")
        .where('_time', isGreaterThanOrEqualTo: endDate)
        .orderBy('_time', descending: true)
        .get();

    print("element size : ${data.docs.length}");
    data.docs.forEach((element) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(
          element.get("_time").seconds * 1000);
      String formattedDate =
          DateFormat.MMMd().format(date).replaceAll(" ", ", ");
      dateList.add(formattedDate);
    });

    if (data.docs.length == 0) {
      nodata = true;
    }

    _tabs = await getTabs(dateList.length);
    _children = await getWidget(dateList.length);

    setState(() {});
  }

  List<Tab> getTabs(int count) {
    _tabs.clear();
    for (int i = 0; i < count; i++) {
      _tabs.add(
        Tab(
          child: SizedBox(
            width: 90.w,
            child: Center(
                child: Text(
              dateList[i],
              style:
                  GoogleFonts.josefinSans(color: Colors.grey, fontSize: 17.sp),
            )),
          ),
        ),
      );
    }
    return _tabs;
  }

  List<Widget> getWidget(int count) {
    _children.clear();
    for (int i = 0; i < count; i++) {
      _children.add(body(data.docs[i].id));
    }
    return _children;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: dateList.length,
      child: Scaffold(
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
            "Last_Orders".tr(),
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
        body: _tabs.isNotEmpty
            ? Column(
                children: [
                  SizedBox(
                    height: 50.h,
                    child: TabBar(
                      isScrollable: true,
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: _tabs,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      //child: Text("This is last order screen"),
                      child: TabBarView(
                        children: _children,
                      ),
                    ),
                  ),
                ],
              )
            : nodata == true
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5.h),
                          height: 300.h,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                            image: NetworkImage(images.no_order_image),
                            fit: BoxFit.fill,
                          )),
                        ),
                        Text(
                          "No_order_in_last_week".tr(),
                          style: GoogleFonts.josefinSans(
                              fontSize: 16.sp, color: Colors.green),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child:
                        Image.asset('assets/images/loading.gif', height: 30.h),
                  ),
      ),
    );
  }

  Widget body(String id) {
    return FutureBuilder<QuerySnapshot>(
        future: fs
            .collection("Orders")
            .doc(all_uid)
            .collection("orders")
            .doc(id)
            .collection("orders")
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            double totalPrice = 0;

            snapshot.data!.docs.forEach((element) {
              totalPrice += element.get("_price") * element.get("_itemcount");
            });

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      itemCount: snapshot.data!.docs.length,
                      separatorBuilder: (_, index) => Divider(
                            thickness: 0,
                            height: 7.h,
                          ),
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 110.h,
                          child: Card(
                            elevation: 10,
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 110.h,
                                  width: 110.h,
                                  child: Stack(
                                    children: [
                                      Center(
                                          child: Image.asset(
                                        'assets/images/loading.gif',
                                        height: 30.h,
                                      )),
                                      Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                          image: NetworkImage(snapshot
                                              .data!.docs[index]
                                              .get("_url")),
                                          fit: BoxFit.cover,
                                        )),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 110.h,
                                  width: 199.w,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 20.w, top: 15.h, right: 30.w),
                                        child: Text(
                                          capitalize(snapshot.data!.docs[index]
                                              .get("_name")),
                                          style: GoogleFonts.josefinSans(
                                            fontSize: 17.sp,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 20.w, top: 5.h, right: 10.w),
                                        child: Text(
                                          capitalize(snapshot.data!.docs[index]
                                              .get("_category")),
                                          style: GoogleFonts.josefinSans(
                                              fontSize: 15.sp,
                                              letterSpacing: 1),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 20.w, top: 12.h),
                                        child: Text.rich(TextSpan(
                                            text:
                                                "\$${snapshot.data!.docs[index].get("_price")}",
                                            style: GoogleFonts.josefinSans(
                                                fontSize: 18.sp,
                                                color: Colors.green,
                                                letterSpacing: 0),
                                            children: <InlineSpan>[
                                              TextSpan(
                                                text: snapshot.data!.docs[index]
                                                            .get("_itemcount") >
                                                        1
                                                    ? ' x '
                                                    : '',
                                                style: GoogleFonts.josefinSans(
                                                    fontSize: 14.sp,
                                                    color: Colors.black54),
                                              ),
                                              TextSpan(
                                                text: snapshot.data!.docs[index]
                                                            .get("_itemcount") >
                                                        1
                                                    ? snapshot.data!.docs[index]
                                                        .get("_itemcount")
                                                        .toString()
                                                    : '',
                                                style: GoogleFonts.josefinSans(
                                                    fontSize: 18.sp,
                                                    color: Colors.black54),
                                              )
                                            ])),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  height: 50.h,
                  width: double.infinity,
                  color: Colors.green,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          late ItemsData hivedata;
                          snapshot.data!.docs.forEach((element) {
                            try {
                              hivedata = box.get(element.get("_name"));
                              if (hivedata.itemCount == 0) {
                                all_cart += 1;
                              }
                              hivedata.itemCount +=
                                  (element.get("_itemcount") as int);
                              hivedata.save();
                            } catch (e) {
                              print("this is catch");
                              print("errro : $e");
                              hivedata = ItemsData(
                                  name: element.get("_name"),
                                  url: element.get("_url"),
                                  detail: element.get("_detail"),
                                  price: element.get("_price"),
                                  favourite: false,
                                  itemCount: element.get("_itemcount"),
                                  category: element.get("_category"));
                              box.put(element.get("_name"), hivedata);
                              all_cart += 1;
                            }
                          });
                          setState(() {});
                          snackbar(context, "All_Items_added_to_cart".tr());
                        },
                        child: Text(
                          "REPEAT_ORDER".tr(),
                          style: GoogleFonts.josefinSans(
                              fontSize: 18.sp, color: Colors.white),
                        ),
                      ),
                      Text(
                        "\$${totalPrice.toString()}",
                        style: GoogleFonts.josefinSans(
                            fontSize: 20.sp, color: Colors.white),
                      )
                    ],
                  ),
                )
              ],
            );
          } else {
            return Center(
              child: Image.asset('assets/images/loading.gif', height: 30.h),
            );
          }
        });
  }
}
