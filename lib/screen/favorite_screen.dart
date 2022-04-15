import 'package:easy_localization/src/public_ext.dart';
import 'package:eat_it_ppsu/models/hive_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../main.dart';
import '../style.dart';

class Favoritepage extends StatefulWidget {
  final VoidCallback openDrawer;
  const Favoritepage({Key? key, required this.openDrawer}) : super(key: key);

  @override
  State<Favoritepage> createState() => _FavoritepageState();
}

class _FavoritepageState extends State<Favoritepage> {
  bool edit = false;
  int count = 0;
  late List<bool> selected;
  late List<ItemsData> list;

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
            child: Padding(
          padding: EdgeInsets.only(left: 15.w),
          child: Text(
            "Favourite".tr(),
            style: GoogleFonts.josefinSans(fontSize: 22.sp),
          ),
        )),
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
                child: Container(
              width: 80.w,
              padding: EdgeInsets.only(right: 10.w),
              child: Center(
                  child: Text(
                edit ? "Cancel".tr() : "Edit".tr(),
                style: GoogleFonts.josefinSans(fontSize: 22.sp),
              )),
            )),
          ),
        ],
      ),
      //drawer: DrawerScreen(),

      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white30,
              width: double.infinity,
              padding: EdgeInsets.only(
                  top: 10.h, bottom: 10.h, left: 10.h, right: 10.h),
              child: ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder: (BuildContext context, Box<dynamic> items, _) {
                  List<ItemsData> datalist = items.values
                      .where((element) => element.favourite == true)
                      .cast<ItemsData>()
                      .toList();

                  list = datalist;
                  !edit
                      ? selected = List<bool>.generate(
                          datalist.length, (index) => false,
                          growable: true)
                      : selected;
                  return datalist.isNotEmpty
                      ? ListView.separated(
                          //padding: EdgeInsets.only(bottom: 0),
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
                                                  : const Center(), //Checkbox
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
                                                            fontSize: 18,
                                                            color: Colors.green,
                                                            letterSpacing: 0),
                                                    children: <InlineSpan>[
                                                      TextSpan(
                                                        text: data.itemCount > 1
                                                            ? ' x '
                                                            : '',
                                                        style: GoogleFonts
                                                            .josefinSans(
                                                                fontSize: 14,
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
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .black54),
                                                      )
                                                    ])),
                                                data.itemCount > 0 && !edit
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
                                                            const VerticalDivider(
                                                              width: 0,
                                                              thickness: 1,
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  data.itemCount +=
                                                                      1;
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
                                                    : !edit
                                                        ? Container(
                                                            height: 35.h,
                                                            width: 35.w,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.green,
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5.r)),
                                                            ),
                                                            child: InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  data.itemCount +=
                                                                      1;
                                                                  data.save();
                                                                });
                                                              },
                                                              child: Container(
                                                                height: 35.h,
                                                                width: 35.w,
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .local_grocery_store_outlined,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 25.sp,
                                                                  ),
                                                                ),
                                                              ),
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
                          child: Text(
                          'Empty',
                          style: GoogleFonts.josefinSans(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 20.sp),
                        ));
                },
              ),
            ),
          ),
          edit
              ? InkWell(
                  onTap: () {
                    for (int i = 0; i < selected.length; i++) {
                      if (selected[i]) {
                        list[i].favourite = false;
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
                            "DELETE".tr(),
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
                )
              : const Center(),
        ],
      ),
    );
  }
}
