import 'package:easy_localization/src/public_ext.dart';
import 'package:eat_it_ppsu/screen/address_screen.dart';
import 'package:eat_it_ppsu/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class Checkout extends StatefulWidget {
  VoidCallback orderdone;
  double totalPrice;
  Checkout({Key? key, required this.orderdone, required this.totalPrice})
      : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String address = "Select_your_address".tr();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        goBack(context);
        return false;
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
              onPressed: () => goBack(context),
            ),
          ),
          title: Center(
              child: Text(
            "Ordering".tr(),
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
        body: Container(
          width: double.infinity,
          color: Colors.grey.shade200,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 30.h, left: 20.w),
                      child: Text(
                        "Delivery_address".tr(),
                        style: GoogleFonts.josefinSans(
                            fontSize: 17,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      child: InkWell(
                        onTap: () async {
                          await Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: Addresspage((String add) {
                                    setState(() {
                                      if (add != "") {
                                        address = add;
                                      }
                                    });
                                  })));
                        },
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 10.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 5.h),
                                        child: Text(
                                          "Address_1".tr(),
                                          style: GoogleFonts.josefinSans(
                                              fontSize: 14.sp,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.6.w),
                                        ),
                                      ),
                                      Text(address,
                                          style: GoogleFonts.josefinSans(
                                              fontSize: 17.sp,
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              letterSpacing: 0.5.w)),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 18.sp,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.h, left: 20.w),
                      child: Text(
                        "Payment_Method".tr(),
                        style: GoogleFonts.josefinSans(
                            fontSize: 17,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      child: InkWell(
                        onTap: () {
                          print("its done");
                        },
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 10.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio(
                                  value: 1,
                                  groupValue: 1,
                                  onChanged: (value) {},
                                ),
                                Text("Cash_on_delivery".tr(),
                                    style: GoogleFonts.josefinSans(
                                        fontSize: 17.sp,
                                        color: Colors.black.withOpacity(0.6),
                                        letterSpacing: 0.5.w)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                      onTap: address != "Select_your_address".tr()
                          ? widget.orderdone
                          : () => snackbar(
                              context, "Please_select_address_first".tr()),
                      // onTap: (){
                      //   print("address : ${address}");
                      // },
                      child: Text(
                        "CHECKOUT".tr(),
                        style: GoogleFonts.josefinSans(
                            fontSize: 16.sp, color: Colors.white),
                      ),
                    ),
                    Text(
                      "\$${widget.totalPrice}",
                      style: GoogleFonts.josefinSans(
                          fontSize: 20.sp, color: Colors.white),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> goBack(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        // title: const Text('Error'),
        content: Text(
          "You_want_to_cancel_order".tr(),
          style: GoogleFonts.josefinSans(),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 80.w,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey),
                  ),
                  child: Text(
                    "CANCEL".tr(),
                    style: GoogleFonts.josefinSans(fontSize: 12.sp),
                  ),
                ),
              ),
              Container(
                width: 80.w,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "OK".tr(),
                    style: GoogleFonts.josefinSans(fontSize: 12.sp),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
