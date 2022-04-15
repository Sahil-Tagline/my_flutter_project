import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it_ppsu/auth_screen/sign_in.dart';
import 'package:eat_it_ppsu/images_link.dart';
import 'package:eat_it_ppsu/screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_screen/sign_up.dart';
import 'drawer/home.dart';
import 'models/hive_model.dart';
import 'style.dart';

late Box box;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<ItemsData>(ItemsDataAdapter());
  box = await Hive.openBox<ItemsData>('itemsdata1');

  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid =
      const AndroidInitializationSettings('notificatrion_icon');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int? id, String? title, String? body, String? payload) async {});
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      debugPrint('Notification Payload: ' + payload);
    }
  });

  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'BR'),
        Locale('en', 'US'),
      ],
      path: 'assets/translations',
      saveLocale: true,
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  late int is_logedin;
  bool is_Splash = true;

  @override
  void initState() {
    is_logedin = 0;
    super.initState();
    Timer(const Duration(seconds: 3), () {
      setState(() {
        is_Splash = false;
      });
    });
  }

  void login_setup() async {
    final prefs = await SharedPreferences.getInstance();
    is_logedin = (prefs.getInt('islogedin') ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/main': (BuildContext context) => const MyHomePage(), //new
      },
      home: is_Splash
          ? const SplashScreen()
          : FutureBuilder(
              future: _fbApp,
              builder: (context, snapshot) {
                login_setup(); //-----------------------------------------  login check
                if (snapshot.hasError) {
                  print("Error :- ${snapshot.error.toString()}");
                  return Text(
                    "Something Went Wrong!",
                    style: GoogleFonts.josefinSans(),
                  );
                } else if (snapshot.hasData) {
                  // login_setup();
                  if (is_logedin == 1) {
                    return const HomePage();
                  } else {
                    return const MyHomePage();
                  }
                } else {
                  return Center(
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: const AssetImage(images.home_food),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.6),
                                  BlendMode.srcOver)),
                        ),
                        child: Image.asset('assets/images/eat_it_logo.png')),
                  );
                }
              },
            ),
      // home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  Future<String?> goBack(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Exit App',
          style: GoogleFonts.josefinSans(
              fontWeight: FontWeight.bold, fontSize: 22),
        ),
        content: Text(
          'Are you sure you want to exit?',
          style: GoogleFonts.josefinSans(fontSize: 18),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 80.w,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.close, color: Colors.white),
                  label: Text(
                    'No',
                    style: GoogleFonts.josefinSans(color: Colors.white),
                  ),
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(color: Colors.black))),
                  ),
                ),
              ),
              SizedBox(
                width: 80.w,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: Text(
                    'Yes',
                    style: GoogleFonts.josefinSans(color: Colors.white),
                  ),
                  onPressed: () => SystemNavigator.pop(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(color: Colors.black))),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(360, 690),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);

    return WillPopScope(
      onWillPop: () async {
        goBack(context);
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            //----------------------------------------------------------------------------- background image
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: const AssetImage(images.home_food),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6), BlendMode.srcOver),
              )),
            ),
            //----------------------------------------------------------------------------- body
            Center(
              child: _body(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      //physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 170.h, right: 15.w),
            child: Image.asset(images.eat_it_logo),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30.w, 80.h, 30.w, 0),
            child: Text(
              "mainpage_description".tr(),
              style: text_style,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 125.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 15.w),
                  height: 45.h,
                  width: 140.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    child: Text(
                      "SIGN_UP".tr(),
                      style: GoogleFonts.montserrat(fontSize: 17.sp),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: const SignUp()));
                    },
                  ),
                ),
                Container(
                  height: 45.h,
                  width: 140.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                    ),
                    child: Text(
                      "SIGN_IN".tr(),
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(color: Colors.black),
                          fontSize: 17.sp),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade, child: SignIn()));
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
