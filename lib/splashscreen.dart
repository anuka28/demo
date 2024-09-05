import 'package:Anyquire/HomeController.dart';
import 'package:Anyquire/homescreen.dart';
import 'package:Anyquire/introscreen.dart';
import 'package:Anyquire/userlogin.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:Anyquire/main.dart';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool AlreadyLoggedin = false;
  @override
  void initState() {
    boolCheckMethod();
    // TODO: implement initState
    super.initState();
  }

  boolCheckMethod() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    //  bool FirstTime = sharedPreferences.getBool('initialLogin') ?? true;

    AlreadyLoggedin = await sharedPreferences.getBool('loggedin') ?? false;
    setState(() {});
    print('isLoggedin: $AlreadyLoggedin');
    // setState(() {
    //   // initialLogin = FirstTime;
    //   registeredUser = AlreadyLoggedin;
    //   print('$registeredUser');
    // });
  }

  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      nextScreen:
          //IntroScreen(),
          (AlreadyLoggedin) ? HomeController() : IntroScreen(),
      //(registeredUser == true) ? HomeScreen('') :
      // LoginScreen(),
      //(registeredUser == true) ? HomePage() :
      // LoginScreen(),
      duration: 1,
      // backgroundColor: Colwhite,
      animationDuration: Duration(seconds: 1),
      splashIconSize: 450,
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/anyquire-logoo.png',
            width: 300,
            height: 200,
          ),
        ],
      ),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.bottomToTop,
    );
  }
}
