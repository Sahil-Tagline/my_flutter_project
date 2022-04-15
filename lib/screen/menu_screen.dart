import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:eat_it_ppsu/screen/items_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../style.dart';

class Menupage extends StatefulWidget {
  final VoidCallback openDrawer;
  const Menupage({Key? key, required this.openDrawer}) : super(key: key);

  @override
  State<Menupage> createState() => _MenupageState();
}

class _MenupageState extends State<Menupage> {
  int round = 0;
  late int total;
  late QuerySnapshot<Map<String, dynamic>> data;

  @override
  void initState() {
    get_data();
    super.initState();
  }

  get_data() async {
    bool isOnline = await hasNetwork();
    if (isOnline) {
      try {
        data = await fs.collection("category").get();
        print(data.docs[0].data());

        setState(() {
          round = ((data.size) / 4).ceil();
          total = data.size;
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
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(
          width: 47.h,
          child: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
              size: 30.sp,
            ),
            onPressed: widget.openDrawer,
          ),
        ),
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 47.w),
            child: Text(
              "Menu".tr(),
              style: GoogleFonts.josefinSans(fontSize: 22.sp),
            ),
          ),
        ),
        backgroundColor: Colors.black,
        // actions: [
        //   SizedBox(
        //     width: 47.h,
        //     child: IconButton(
        //       icon: Icon(
        //         Icons.search,
        //         color: Colors.white,
        //         size: 30.sp,
        //       ),
        //       onPressed: () {},
        //     ),
        //   ),
        // ],
      ),
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    int index = 0;
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        itemCount: round,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int position) {
          if (index + 4 <= total) {
            int i = index;
            index = index + 4;
            return Model1(context, i);
          } else if (index + 3 == total) {
            int i = index;
            index = index + 3;
            return Model2(context, i);
          } else if (index + 2 == total) {
            int i = index;
            index = index + 2;
            return Model3(context, i);
          } else if (index + 1 == total) {
            int i = index;
            index = index + 1;
            return Model4(context, i);
          }
          return const Center();
        },
      ),
    );
  }

  Model1(BuildContext context, int i) {
    return Column(
      children: [
        _box1(context, i),
        Row(
          children: [
            _box2(context, i + 1),
            Column(
              children: [
                _box3(context, i + 2),
                _box3(context, i + 3),
              ],
            )
          ],
        ),
      ],
    );
  }

  Model2(BuildContext context, int i) {
    return Column(
      children: [
        _box1(context, i),
        Row(
          children: [
            _box2(context, i + 1),
            _box2(context, i + 2),
          ],
        ),
      ],
    );
  }

  Model3(BuildContext context, int i) {
    return Column(
      children: [
        _box1(context, i),
        _box1(context, i + 1),
      ],
    );
  }

  Model4(BuildContext context, int i) {
    return _box1(context, i);
  }

  _box1(BuildContext context, int i) {
    return InkWell(
      onTap: () => _onTap(data.docs[i]),
      child: SizedBox(
        width: double.infinity,
        height: 250.h,
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
                image: NetworkImage(data.docs[i].get("_url")),
                fit: BoxFit.cover,
              )),
              child: style(context, data.docs[i].get("_name"),
                  data.docs[i].get("_count")),
            ),
          ],
        ),
      ),
    );
  }

  _box2(BuildContext context, int i) {
    return InkWell(
      onTap: () => _onTap(data.docs[i]),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: 365.5.h,
        child: Stack(
          children: [
            Center(
                child: Image.asset('assets/images/loading.gif', height: 30.h)),
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(data.docs[i].get("_url")),
                fit: BoxFit.cover,
              )),
              child: style(context, data.docs[i].get("_name"),
                  data.docs[i].get("_count")),
            ),
          ],
        ),
      ),
    );
  }

  _box3(BuildContext context, int i) {
    return InkWell(
      onTap: () => _onTap(data.docs[i]),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: 182.7.h,
        child: Stack(
          children: [
            Center(
                child: Image.asset('assets/images/loading.gif', height: 30.h)),
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(data.docs[i].get("_url")),
                fit: BoxFit.cover,
              )),
              child: style(context, data.docs[i].get("_name"),
                  data.docs[i].get("_count")),
            ),
          ],
        ),
      ),
    );
  }

  style(BuildContext context, String name, int itemCount) {
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                name,
                style:
                    GoogleFonts.josefinSans(fontSize: 25, color: Colors.white),
              ),
              Text(
                itemCount.toString(),
                style:
                    GoogleFonts.josefinSans(fontSize: 25, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onTap(QueryDocumentSnapshot<Map<String, dynamic>> items) {
    if (items.get("_count") != 0) {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade, child: ItemsPage(items)));
    }
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    await get_data();
  }
}
