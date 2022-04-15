import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:eat_it_ppsu/images_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../style.dart';

class DrawerScreen extends StatefulWidget {
  final ValueChanged<String> onSelectedItem;

  const DrawerScreen({Key? key, required this.onSelectedItem})
      : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  String type = "";
  late bool isPhone;

  @override
  void initState() {
    set_sharepreference();
    super.initState();
  }

  void set_sharepreference() async {
    //box.deleteAll(box.keys);
    //box.deleteFromDisk();
    //await box.clear();

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('islogedin', 1);

    var pathlist = await fs.collection("Offers").get();
    all_offer = pathlist.size;

    all_uid = await (prefs.getString('UserId') ?? "");
    all_user = await (prefs.getString("UserName") ?? "User Name");
    notificationStatus = await (prefs.getBool("NotificationStatus") ?? true);

    if (all_user.isEmpty || all_user == "User Name") {
      final fs = FirebaseFirestore.instance;
      fs.collection("UserDetails").doc(all_uid).get().then((value) async {
        setState(() {
          all_user = value.get("_name").toString().trim();
          all_url = value.get("_image").toString();
          type = value.get("_phone").toString();
        });

        await prefs.setString('UserName', all_user);
        await prefs.setString('Url', all_url);
        await prefs.setString('Type', type);

        isPhone = checkType(type);
        await prefs.setBool('isPhone', isPhone);
      });
    } else {
      setState(() {
        all_url = (prefs.getString("Url") ?? "");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = box.values.where((element) => element.itemCount > 0);
    all_cart = size.length;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(images.home_food),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black54.withOpacity(0.7), BlendMode.srcOver),
          )),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Drawerbody(context, widget.onSelectedItem),
          ),
        ),
      ],
    );
  }
}

Widget Drawerbody(context, ValueChanged<String> onSelectedItem) {
  return SingleChildScrollView(
    child: Container(
      margin: EdgeInsets.only(top: 100.h, right: 90.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //------------------------------------------------------------------------------------------------- header
          Container(
            margin: EdgeInsets.only(left: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 45.r,
                  backgroundColor: Color(0xff2b3230).withOpacity(0.8),
                  backgroundImage: AssetImage(images.defalt_pro_pic),
                  child: CircleAvatar(
                    radius: 45.r,
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                        all_url.isNotEmpty ? NetworkImage(all_url) : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.h),
                  child: Text(
                    all_user,
                    style: GoogleFonts.josefinSans(
                        color: Colors.white, fontSize: 20.sp),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 5.h,
                  ),
                  child: InkWell(
                    onTap: () {
                      print("Account");
                      onSelectedItem("Account");
                      isSelected = "Account";
                    },
                    child: Text(
                      "Edit_profile".tr(),
                      style: GoogleFonts.josefinSans(
                          color: Colors.green, fontSize: 17.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //------------------------------------------------------------------------------------------------- Drawer Items

          Column(
            children: [
              Container(
                //color: Colors.black.withOpacity(0.7),
                margin: EdgeInsets.only(top: 15.h),
                child: createDrawerBodyItem(
                    icon: Icons.restaurant_menu_outlined,
                    title: 'Menu'.tr(),
                    onSelectedItem: onSelectedItem),
              ),
              createDrawerBodyItem(
                  icon: Icons.local_offer_outlined,
                  title: 'Offers'.tr(),
                  onSelectedItem: onSelectedItem),
              createDrawerBodyItem(
                  icon: Icons.shopping_cart_outlined,
                  title: 'My_Cart'.tr(),
                  onSelectedItem: onSelectedItem),
              createDrawerBodyItem(
                  icon: Icons.watch_later_outlined,
                  title: 'Last_Order'.tr(),
                  onSelectedItem: onSelectedItem),
              createDrawerBodyItem(
                  icon: Icons.star_border,
                  title: 'Favourite'.tr(),
                  onSelectedItem: onSelectedItem),
              createDrawerBodyItem(
                  icon: Icons.settings,
                  title: 'Settings'.tr(),
                  onSelectedItem: onSelectedItem),
              createDrawerBodyItem(
                  icon: Icons.textsms_outlined,
                  title: 'Support'.tr(),
                  onSelectedItem: onSelectedItem),
              createDrawerBodyItem(
                  icon: Icons.logout,
                  title: 'Log_Out'.tr(),
                  onSelectedItem: onSelectedItem),
            ],
          ),
        ],
      ),
    ),
  );
}
