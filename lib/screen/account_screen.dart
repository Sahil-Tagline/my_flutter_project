import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it_ppsu/images_link.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../style.dart';

class Accountpage extends StatefulWidget {
  final VoidCallback openDrawer;
  final ValueChanged<bool> onUpdate;
  const Accountpage(
      {Key? key, required this.openDrawer, required this.onUpdate})
      : super(key: key);

  @override
  State<Accountpage> createState() => _AccountpageState();
}

class _AccountpageState extends State<Accountpage> {
  String _name = all_user;
  String type = "";
  bool isPhone = false;
  bool _inProcess = false;
  final fs = FirebaseFirestore.instance;

  @override
  void initState() {
    getData();
  }

  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      type = (prefs.getString("Type") ?? "");
      isPhone = (prefs.getBool("isPhone") ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController name1 = TextEditingController(text: _name);
    TextEditingController phone1 = TextEditingController(text: type);
    TextEditingController password1 = TextEditingController(text: "123456");
    name1.selection =
        TextSelection.fromPosition(TextPosition(offset: name1.text.length));
    phone1.selection =
        TextSelection.fromPosition(TextPosition(offset: phone1.text.length));

    return WillPopScope(
      onWillPop: () async {
        if (_inProcess == true) {
          setState(() {
            _inProcess = false;
          });

          return true;
        }
        return true;
      },
      child: Stack(
        children: [
          Container(
            //background image
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage(images.home_food),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6), BlendMode.srcOver),
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
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
                "Account".tr(),
                style: GoogleFonts.josefinSans(fontSize: 22.sp),
              )),
              backgroundColor: Colors.black,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.power_settings_new,
                    color: Colors.white,
                    size: 30.sp,
                  ),
                  onPressed: () {
                    logout(context);
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30.h, bottom: 30.h, left: 30.w),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 45.r,
                        backgroundImage: AssetImage(images.defalt_pro_pic),
                        child: CircleAvatar(
                          radius: 45.r,
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              all_url.isNotEmpty ? NetworkImage(all_url) : null,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 13.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              all_user,
                              style: GoogleFonts.josefinSans(
                                  color: Colors.white, fontSize: 22.sp),
                            ),
                            InkWell(
                              highlightColor: Colors.white,
                              onTap: () {
                                _showDialog(context);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(top: 5.h),
                                child: Text(
                                  "Edit_Photo".tr(),
                                  style: GoogleFonts.josefinSans(
                                      color: Colors.green, fontSize: 18.sp),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      margin: EdgeInsets.only(top: 20.h),
                      child: Column(
                        children: [
                          Container(
                            width: 300.w,
                            height: 55.h,
                            child: TextField(
                              onChanged: (text) {
                                setState(() {
                                  _name = text;
                                });
                              },
                              controller: name1,
                              maxLength: 18,
                              textCapitalization: TextCapitalization.words,
                              cursorColor: Colors.grey,
                              style: GoogleFonts.josefinSans(
                                  color: Colors.black54, fontSize: 20.sp),
                              decoration: InputDecoration(
                                labelText: 'Name'.tr(),
                                counterText: '',
                                labelStyle: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.green,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black26),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 300.w,
                            height: 55.h,
                            margin: EdgeInsets.only(top: 15.h),
                            child: TextField(
                              enabled: false,
                              controller: phone1,
                              cursorColor: Colors.grey,
                              style: GoogleFonts.josefinSans(
                                  color: Colors.black54, fontSize: 20.sp),
                              decoration: InputDecoration(
                                labelText:
                                    isPhone ? 'Phone'.tr() : 'Email'.tr(),
                                labelStyle: GoogleFonts.josefinSans(
                                  fontSize: 20.sp,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                          isPhone
                              ? InkWell(
                                  onTap: () {
                                    bottomSheet(context);
                                  },
                                  child: Container(
                                    width: 300.w,
                                    height: 55.h,
                                    margin: EdgeInsets.only(top: 15.h),
                                    child: TextField(
                                      enabled: false,
                                      cursorColor: Colors.white,
                                      controller: password1,
                                      obscureText: true,
                                      style: GoogleFonts.josefinSans(
                                          color: Colors.black54,
                                          fontSize: 20.sp),
                                      decoration: InputDecoration(
                                        labelText: 'Password'.tr(),
                                        labelStyle: GoogleFonts.josefinSans(
                                          fontSize: 20.sp,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const Center(),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 55.h,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary:
                          all_user == _name.trim() ? Colors.grey : Colors.green,
                    ),
                    child: Text(
                      "SAVE".tr(),
                      style: GoogleFonts.montserrat(
                          fontSize: 18.sp, letterSpacing: 0.5.sp),
                    ),
                    onPressed: () {
                      if (all_user != _name.trim()) {
                        _save(context, _name.trim());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          (_inProcess)
              ? Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height * 1,
                  child: Center(
                    child:
                        Image.asset('assets/images/loading.gif', height: 30.h),
                  ),
                )
              : const Center(),
        ],
      ),
    );
  }

  void _save(BuildContext context, String _name) async {
    String oldName = all_user;
    bool isOnline = await hasNetwork();
    if (isOnline) {
      if (_name != all_user && _name.isNotEmpty) {
        alertdialogText(context, "Please_wait...".tr());
        try {
          final prefs = await SharedPreferences.getInstance();
          fs
              .collection("UserDetails")
              .doc(all_uid)
              .update({"_name": _name}).then((value) async {
            await prefs.setString('UserName', _name);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            alertdialog(context, "Name_Successfully_Updated".tr());
            setState(() {
              all_user = _name;
            });
          });
        } catch (e) {
          Navigator.pop(context);
          alertdialog(context, "Some_thing_went_wrong_Please_try_again".tr());
        }

        //------------------------------------------------------------------------------------------------------ update name in every place (comments)
        fs.collection("Comments").get().then((value) {
          value.docs.forEach((element) {
            fs
                .collection("Comments")
                .doc(element.id)
                .collection("comment")
                .where("_name", isEqualTo: oldName)
                .get()
                .then((value1) {
              value1.docs.forEach((element1) {
                fs
                    .collection("Comments")
                    .doc(element.id)
                    .collection("comment")
                    .doc(element1.id)
                    .update({"_name": all_user});
              });
            });
          });
        });
      } else {
        alertdialog(context, "Name_should_not_empty".tr());
      }
    } else {
      alertdialog(context, "Please_check_your_connection".tr());
    }
  }

  Future bottomSheet(BuildContext context) {
    TextEditingController cPassController = TextEditingController();
    TextEditingController nPassController = TextEditingController();

    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Stack(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r)),
                  image: DecorationImage(
                    image: AssetImage(images.home_food),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black54.withOpacity(0.8), BlendMode.srcOver),
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30.h),
                    child: Center(
                      child: Text(
                        "UPDATE_PASSWORD".tr(),
                        style: GoogleFonts.josefinSans(
                            color: Colors.green, fontSize: 25.sp),
                      ),
                    ),
                  ),
                  Container(
                    width: 250.w,
                    height: 50.h,
                    margin: EdgeInsets.only(top: 30.h),
                    child: TextField(
                      cursorColor: Colors.white,
                      controller: cPassController,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: textfield,
                      decoration: InputDecoration(
                        labelText: 'Current_Password'.tr(),
                        counterText: '',
                        labelStyle: GoogleFonts.josefinSans(
                          fontSize: 20.sp,
                          color: Colors.green,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 250.w,
                    height: 50.h,
                    margin: EdgeInsets.only(top: 10.h),
                    child: TextField(
                      cursorColor: Colors.white,
                      controller: nPassController,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: textfield,
                      decoration: InputDecoration(
                        labelText: 'New_Password'.tr(),
                        counterText: '',
                        labelStyle: GoogleFonts.josefinSans(
                          fontSize: 20.sp,
                          color: Colors.green,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 20.h, left: 55.w),
                    child: Text(
                      "Password_must_have_6_digit".tr(),
                      style: GoogleFonts.josefinSans(
                          fontSize: 15.sp, color: Colors.green),
                    ),
                  ),
                  Container(
                    height: 45.h,
                    width: 250.w,
                    margin: EdgeInsets.only(top: 80.h),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      child: Text(
                        "UPDATE".tr(),
                        style: GoogleFonts.montserrat(
                            fontSize: 20.sp, letterSpacing: 0.5.sp),
                      ),
                      onPressed: () {
                        if (cPassController.text.isNotEmpty &&
                            cPassController.text.length == 6 &&
                            nPassController.text.isNotEmpty &&
                            nPassController.text.length == 6) {
                          if (cPassController.text != nPassController.text) {
                            _update(context, cPassController.text,
                                nPassController.text);
                          } else {
                            alertdialog(
                                context,
                                "Current_Password_and_New_Password_should_not_same"
                                    .tr());
                          }
                        } else {
                          alertdialog(
                              context, "Password_should_have_6_digit".tr());
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  void _update(BuildContext context, String cPassword, String nPassword) async {
    bool isOnline = await hasNetwork();
    if (isOnline) {
      try {
        alertdialogText(context, "Please_wait...".tr());
        fs.collection("AllUsers").doc(type).get().then((value) {
          if (value.get("_password") == cPassword) {
            fs
                .collection("AllUsers")
                .doc(type)
                .update({"_password": nPassword}).then((value) {
              Navigator.pop(context);
              Navigator.pop(context);
              alertdialog(context, "Password_Successfully_Updated".tr());
            });
          } else {
            Navigator.pop(context);
            alertdialog(context, "Please_Enter_Correct_Password".tr());
          }
        });
      } catch (e) {
        Navigator.pop(context);
        Navigator.pop(context);
        alertdialog(context, "Some_thing_went_wrong_Please_try_again".tr());
      }
    } else {
      alertdialog(context, "Please_check_your_connection".tr());
    }
  }

  Future _showDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r)), //this right here
        content: Container(
          height: 150.h,
          width: 200.w,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                  child: Text(
                    "Select_Option".tr(),
                    style: GoogleFonts.josefinSans(
                        fontSize: 25.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    size: 40.sp,
                  ),
                  title: Text(
                    "Camera".tr(),
                    style: GoogleFonts.josefinSans(fontSize: 20.sp),
                  ),
                  onTap: () async {
                    ImageSelecter(ImageSource.camera);
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: Icon(
                    Icons.photo,
                    size: 40.sp,
                  ),
                  title: Text(
                    "Gallery".tr(),
                    style: GoogleFonts.josefinSans(fontSize: 20.sp),
                  ),
                  onTap: () async {
                    ImageSelecter(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void ImageSelecter(ImageSource source) async {
    Navigator.pop(context);
    setState(() {
      _inProcess = true;
    });
    final ImagePicker _picker = ImagePicker();
    final file = await _picker.pickImage(source: source);
    if (file != null) {
      final cropped = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 50,
        maxHeight: 700,
        maxWidth: 700,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarWidgetColor: Colors.white,
          toolbarColor: Colors.green,
          statusBarColor: Colors.green,
          toolbarTitle: "Image_Cropper".tr(),
          backgroundColor: Colors.white,
          activeControlsWidgetColor: Colors.green,
        ),
      );

      if (cropped != null) {
        bool isOnline = await hasNetwork();
        if (isOnline) {
          try {
            String link = await uploadImage(File(cropped.path));
            final prefs = await SharedPreferences.getInstance();

            await fs.collection('UserDetails').doc(all_uid).update({
              "_image": link,
            }).then((value) async {
              await prefs.setString("Url", link);

              setState(() {
                all_url = link;
                _inProcess = false;
              });
              alertdialog(context, "Photo_Successfully_Updated".tr());
            });
          } catch (e) {
            //Navigator.pop(context);
            alertdialog(context, "Some_thing_went_wrong_Please_try_again".tr());
          }
        } else {
          alertdialog(context, "Please_check_your_connection".tr());
        }
      }
    }
    setState(() {
      _inProcess = false;
    });
  }

  Future<String> uploadImage(File image) async {
    Reference db = FirebaseStorage.instance.ref("Users_pic/${type}");
    await db.putFile(image);

    return await db.getDownloadURL();
  }
}
