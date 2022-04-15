import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:eat_it_ppsu/models/hive_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../main.dart';
import '../style.dart';
import 'cart_screen.dart';

class Offerpage extends StatefulWidget {
  final VoidCallback openDrawer;
  const Offerpage({Key? key, required this.openDrawer}) : super(key: key);

  @override
  State<Offerpage> createState() => _OfferpageState();
}

class _OfferpageState extends State<Offerpage> {
  late ItemsData hivedata;
  late QuerySnapshot<Map<String, dynamic>> pathlist;
  List<QuerySnapshot<Map<String, dynamic>>> datalist = [];
  PageController _pageController =
      PageController(viewportFraction: 0.8, initialPage: 0);

  int activePage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_pageController = PageController(viewportFraction: 0.8, initialPage: 1);
    getdata();
  }

  void getdata() async {
    pathlist = await fs.collection("Offers").get();

    for (int i = 0; i < pathlist.size; i++) {
      QueryDocumentSnapshot element = pathlist.docs[i];
      var data = await fs
          .collection("category")
          .doc(element.get("_category"))
          .collection("items")
          .where("_name", isEqualTo: element.get("_name"))
          .get();

      try {
        hivedata = box.get(data.docs[0].get("_name"));
        hivedata.url = data.docs[0].get("_url");
        hivedata.detail = data.docs[0].get("_detail");
        if (int.parse(data.docs[0].get("_offer")) > 0) {
          hivedata.price = (double.parse(data.docs[0].get("_price")) *
              double.parse(data.docs[0].get("_offer")) /
              100);
        } else {
          hivedata.price = double.parse(data.docs[0].get("_price"));
        }
        hivedata.save();
      } catch (e) {
        print("this is catch");
        print("error : $e");
        hivedata = ItemsData(
            name: data.docs[0].get("_name"),
            url: data.docs[0].get("_url"),
            detail: data.docs[0].get("_detail"),
            price: int.parse(data.docs[0].get("_offer")) > 0
                ? (double.parse(data.docs[0].get("_price")) *
                    double.parse(data.docs[0].get("_offer")) /
                    100)
                : double.parse(data.docs[0].get("_price")),
            favourite: false,
            itemCount: 0,
            category: pathlist.docs[i].get("_category"));
        box.put(pathlist.docs[i].get("_name"), hivedata);
      }

      datalist.add(data);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
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
          "Offers".tr(),
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
      //drawer: DrawerScreen(),

      body: datalist.isNotEmpty
          ? Container(
              color: Colors.grey.shade100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 50.h),
                    width: MediaQuery.of(context).size.width,
                    height: 400.h,
                    child: PageView.builder(
                        itemCount: datalist.length,
                        //pageSnapping: true,
                        controller: _pageController,
                        onPageChanged: (page) {
                          setState(() {
                            activePage = page;
                          });
                        },
                        itemBuilder: (context, pagePosition) {
                          bool active = pagePosition == activePage;
                          return slider(pagePosition, active);
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: indicators(datalist.length, activePage),
                  ),
                  _bottomButton(
                      context, pathlist.docs[activePage].id, activePage),
                ],
              ),
            )
          : Center(
              child: Image.asset('assets/images/loading.gif', height: 30.h),
            ),
    );
  }

  Widget _bottomButton(BuildContext context, String name, int activePage) {
    ItemsData _hivedata = box.get(name);

    return Row(
      children: [
        InkWell(
          onTap: () {
            if (_hivedata.favourite) {
              setState(() {
                _hivedata.favourite = false;
                _hivedata.save();
              });
            } else {
              setState(() {
                _hivedata.favourite = true;
                _hivedata.save();
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
                !_hivedata.favourite
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
                    !_hivedata.favourite
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
            if (_hivedata.itemCount == 0) {
              setState(() {
                all_cart += 1;
                //widget.ontap();
                _hivedata.itemCount += 1;
                _hivedata.save();
              });
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: 50.h,
            color: Colors.green,
            child: _hivedata.itemCount == 0
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
                          if (_hivedata.itemCount == 1) {
                            all_cart -= 1;
                            //widget.ontap();
                          }
                          setState(() {
                            //widget.ontap();
                            _hivedata.itemCount -= 1;
                            _hivedata.save();
                          });
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
                              _hivedata.itemCount.toString(),
                              style: GoogleFonts.josefinSans(
                                  fontSize: 18.sp, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            //widget.ontap();
                            _hivedata.itemCount == 10
                                ? snackbar(context,
                                    'Max limit for this item is 10.\n So you can\'t add more time.')
                                : _hivedata.itemCount += 1;
                            _hivedata.save();
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

  Widget slider(pagePosition, active) {
    double hmargin = active ? 5.w : 15.w;
    double vmargin = active ? 10.h : 30.h;
    double width_name = active ? 180.w : 150.w;

    double price = (double.parse(datalist[pagePosition].docs[0].get("_price")) *
        int.parse(datalist[pagePosition].docs[0].get("_offer")) /
        100);

    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          //curve: Curves.easeInOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(horizontal: hmargin, vertical: vmargin),
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  child: Stack(
                    children: [
                      Center(
                          child: Image.asset('assets/images/loading.gif',
                              height: 30.h)),
                      Container(
                        //color: Colors.yellow,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          image: DecorationImage(
                              image: NetworkImage(
                                datalist[pagePosition].docs[0].get("_url"),
                              ),
                              fit: BoxFit.cover),
                        ),
                        child: Stack(
                          children: [
                            CustomPaint(
                              size: Size(400.w, 400.h),
                              painter: RPSCustomPainter(),
                              child: Container(
                                height: 400.h,
                                width: 400.w,
                                color: Colors.transparent,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 8.h, left: 217.5.w),
                                  child: Text(
                                    "${datalist[pagePosition].docs[0].get("_offer")}%\nOFF",
                                    style: GoogleFonts.josefinSans(
                                        fontSize: 12.sp,
                                        color: Colors.white,
                                        letterSpacing: 1.w,
                                        height: 1.1.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                padding: EdgeInsets.only(top: 7.h, left: 13.h, right: 13.h),
                height: 50.h,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width_name,
                          child: Text(
                            capitalize(
                                datalist[pagePosition].docs[0].get("_name")),
                            style: GoogleFonts.josefinSans(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.8)),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Text(
                          "\$$price",
                          style: GoogleFonts.josefinSans(
                            fontSize: 16.sp,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 3.h),
                          child: Text(
                            capitalize(
                                pathlist.docs[pagePosition].get("_category")),
                            style: GoogleFonts.josefinSans(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                                letterSpacing: 1.w),
                          ),
                        ),
                        Text(
                          "\$${double.parse(datalist[pagePosition].docs[0].get("_price"))}",
                          style: GoogleFonts.josefinSans(
                            fontSize: 16.sp,
                            color: Colors.black54,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: const EdgeInsets.all(3),
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.green : Colors.black26,
            shape: BoxShape.circle),
      );
    });
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 243, 101, 33)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path0 = Path();
    path0.moveTo(210.w, 0);
    path0.lineTo(210.w, 40.h);
    path0.lineTo(230.w, 50.h);
    path0.lineTo(250.w, 40.h);
    path0.lineTo(250.w, 0);

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
