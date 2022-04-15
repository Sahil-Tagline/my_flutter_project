import 'package:eat_it_ppsu/screen/account_screen.dart';
import 'package:eat_it_ppsu/screen/cart_screen.dart';
import 'package:eat_it_ppsu/screen/favorite_screen.dart';
import 'package:eat_it_ppsu/screen/menu_screen.dart';
import 'package:eat_it_ppsu/screen/offer_screen.dart';
import 'package:eat_it_ppsu/screen/orders_screen.dart';
import 'package:eat_it_ppsu/screen/setting_screen.dart';
import 'package:eat_it_ppsu/screen/support_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../style.dart';
import 'drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double xOffset;
  late double yOffset;
  late double scalFactor;
  late bool isDrawerOpen;
  late bool update;
  String item = "Menu";
  bool isDragging = false;

  @override
  void initState() {
    super.initState();

    closeDrawer();
  }

  void closeDrawer() => setState(() {
        xOffset = 0;
        yOffset = 0;
        scalFactor = 1;
        isDrawerOpen = false;
      });

  void openDrawer() => setState(() {
        if (MediaQuery.of(context).viewInsets.bottom != 0) {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        }
        xOffset = 270.w;
        yOffset = 50.w;
        scalFactor = 0.86;
        isDrawerOpen = true;
      });

  @override
  Widget build(BuildContext context) {
    update = false;
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);

    return Stack(
      children: [
        buildDrawer(),
        buildpage(),
      ],
    );
  }

  Widget buildDrawer() {
    return Center(
      child: DrawerScreen(onSelectedItem: (item) {
        if (item == "Log Out") {
          logout(context);
        } else {
          setState(() {
            this.item = item;
          });
          closeDrawer();
        }
      }),
    );
  }

  Widget buildpage() {
    return WillPopScope(
      onWillPop: () async {
        if (isDrawerOpen) {
          closeDrawer();
        } else if (!isDrawerOpen && item != "Menu") {
          setState(() {
            item = "Menu";
          });
          isSelected = "Menu";
          return false;
        }

        return false;
      },
      child: SafeArea(
        top: isDrawerOpen,
        child: GestureDetector(
          onTap: closeDrawer,
          onHorizontalDragStart: (details) => isDragging = true,
          onHorizontalDragUpdate: (details) {
            if (!isDragging) return;

            const delta = 1;
            if (details.delta.dx > delta) {
              openDrawer();
            } else if (details.delta.dx < -delta) {
              closeDrawer();
            }

            isDragging = false;
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(scalFactor),
            child: AbsorbPointer(
              absorbing: isDrawerOpen,
              //child: Menupage(openDrawer: openDrawer),
              child: getPage(),
            ),
          ),
        ),
      ),
    );
  }

  Widget getPage() {
    switch (item) {
      case "Menu":
        return Menupage(openDrawer: openDrawer);
      case "Offers":
        return Offerpage(openDrawer: openDrawer);
      case "My Cart":
        return Cartpage(
          openDrawer,
          type: "home",
        );
      case "Last Order":
        return Orderspage(openDrawer: openDrawer);
      case "Favourite":
        return Favoritepage(openDrawer: openDrawer);
      case "Settings":
        return Settingpage(openDrawer: openDrawer);
      case "Support":
        return Supportpage(openDrawer: openDrawer);
      case "Account":
        return Accountpage(
            openDrawer: openDrawer,
            onUpdate: (bool update) {
              setState(() {
                print("update done in home : $update");
                print("old : ${this.update}");
                this.update = update;
              });
            });

      default:
        return Menupage(openDrawer: openDrawer);
    }
  }
}
