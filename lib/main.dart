import 'package:Anyquire/amplifyconfig.dart';
import 'package:Anyquire/splashscreen.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:amplify_api/amplify_api.dart';

import 'package:flutter/material.dart';

///import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

Color Buttoncolor = Color.fromARGB(255, 96, 97, 237);

Color Textcolor = Color.fromARGB(255, 131, 84, 226);
Color Expertcolor = Color.fromARGB(255, 96, 97, 237);

Color Blackcolor = Color.fromARGB(255, 41, 43, 55);
Color Bluecolor = Color.fromARGB(255, 66, 132, 243);

Color Colwhite = Color.fromARGB(255, 242, 239, 237);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Firebase.initializeApp();

  runApp(Config());
}

class Config extends StatefulWidget {
  const Config({super.key});

  @override
  State<Config> createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  bool isLoggedin = false;
  AmplifyAuthCognito? auth;
  @override
  void initState() {
    _configureAmplify();
    // TODO: implement initState
    super.initState();
  }

  void _configureAmplify() async {
    print("*****************");
    if (!mounted) return;
    auth = AmplifyAuthCognito();
    await Amplify.addPlugins([auth as AmplifyAuthCognito, AmplifyAPI()]);
    try {
      await Amplify.configure(amplifyconfig);

      print('Configured Done!!');
    } catch (e) {
    } on AmplifyAlreadyConfiguredException {
      print('Already Configured!!');
    }
    try {
      // setState(() {
      //   _amplifyConfigured = true;
      // });
    } catch (e) {
      print('error:$e');
    }
  }

  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
