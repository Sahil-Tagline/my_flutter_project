import 'package:eat_it_ppsu/images_link.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animation;
  late Animation<double> _fadeInFadeOut;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1).animate(_animation);

    _animation.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        _animation.forward();
      } else if (status == AnimationStatus.dismissed) {
        _animation.forward();
      }
    });
    _animation.forward();
  }

  @override
  dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeInFadeOut,
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: const AssetImage(images.home_food),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.6), BlendMode.srcOver)),
            ),
            child: Image.asset('assets/images/eat_it_logo.png')),
      ),
    );
  }
}
