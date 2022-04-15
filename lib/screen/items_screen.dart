import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:eat_it_ppsu/screen/item_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../style.dart';
import 'cart_screen.dart';

class ItemsPage extends StatefulWidget {
  QueryDocumentSnapshot<Map<String, dynamic>> items;
  ItemsPage(this.items, {Key? key}) : super(key: key);

  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  late QuerySnapshot<Map<String, dynamic>> data;
  int round = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_data();
  }

  get_data() async {
    bool isOnline = await hasNetwork();
    if (isOnline) {
      try {
        final fs = FirebaseFirestore.instance;
        data = await fs
            .collection("category")
            .doc(widget.items.reference.id)
            .collection("items")
            .get();
        setState(() {
          round = data.size;
        });
        // print("round : $round");

      } catch (e) {
        alertdialog(context, e.toString());
      }
    } else {
      alertdialog(context, "Please_check_your_connection".tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      all_cart;
    });

    return Scaffold(
        appBar: AppBar(
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
              widget.items.get("_name"),
              style: GoogleFonts.josefinSans(fontSize: 22.sp),
            ),
          ),
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
                              child: Cartpage(() {}, type: "items_screen")));
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
        body: ListView.builder(
            itemCount: round,
            itemBuilder: (BuildContext context, int position) {
              return InkWell(
                onTap: () {
                  ontap(context, position);
                },
                child: SizedBox(
                  width: double.infinity,
                  height: 220.h,
                  child: Stack(
                    children: [
                      Center(
                          child: Image.asset('assets/images/loading.gif',
                              height: 30.h)),
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: NetworkImage(data.docs[position].get("_url")),
                          fit: BoxFit.cover,
                        )),
                        child: style(
                            context,
                            data.docs[position].get("_name"),
                            data.docs[position].get("_detail"),
                            data.docs[position].get("_price")),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }

  ontap(BuildContext context, int position) async {
    await Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child: ItemDetailpage(
                data.docs[position], widget.items.get("_name"))));
    setState(() {
      // all_cart;
    });
  }

  style(BuildContext context, String name, String detail, String price) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(),
        Container(
          padding:
              EdgeInsets.only(right: 15.w, bottom: 5.h, top: 5.h, left: 15.w),
          color: Colors.black54.withOpacity(0.7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      capitalize(name),
                      style: GoogleFonts.josefinSans(
                          fontSize: 20, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      capitalize(detail),
                      style: GoogleFonts.josefinSans(
                          fontSize: 15, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              Container(
                child: Text(
                  "\$$price",
                  style: GoogleFonts.josefinSans(
                      fontSize: 25, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
