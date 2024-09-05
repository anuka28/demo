import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:Anyquire/alertbox.dart';
import 'package:Anyquire/api.dart';
import 'package:Anyquire/browser.dart';

import 'package:Anyquire/homescreen.dart';
import 'package:Anyquire/main.dart';
import 'package:Anyquire/user.dart';
import 'package:Anyquire/userlogin.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ConsumerProfilePage extends StatefulWidget {
  const ConsumerProfilePage({super.key});

  @override
  State<ConsumerProfilePage> createState() => _ConsumerProfilePageState();
}

class _ConsumerProfilePageState extends State<ConsumerProfilePage> {
  final _controller = ValueNotifier<bool>(false);
  Map CurrentUser = {};
  RxBool showLoaderDialog = false.obs;
  RxBool showTF = false.obs;
  bool showLoader = true;
  String? userName = "";
  String? tempName = "";
  RxList Status = ['Connect', 'Initiating..', 'Connected', 'Ended'].obs;
  RxList<Color> buttonColors =
      [Textcolor, Textcolor, Colors.green, Colors.red].obs;
  RxInt i = 0.obs;
  RxBool end = false.obs;

  websocketSubscribe() async {
    //   print('wssss  consultantID: ${displayDetails['expert_phone_number']}');
    final wsUrl = Uri.parse(
        "wss://nru1pvaoib.execute-api.ap-south-1.amazonaws.com/Any/?expert_phone_number=+916366317466}");
    print("This is the final url: $wsUrl");
    print("before connect");
    var channel = await WebSocketChannel.connect(wsUrl);

    print("after connect $channel");

    channel.stream.listen((message) async {
      log("yuyuy $message");
      // channel.sink.add('received!');

      //i.value = 2;

      final decodedMessage = await json.decode(message);
      if (decodedMessage.toString().contains("RINGING_AT_EXPERT")) {
        i.value = 1;
      }
      if (decodedMessage.toString().contains("RECEIVED_AT_EXPERT")) {
        i.value = 1;
      }

      if (decodedMessage.toString().contains("RECEIVED_AT_CONSUMER")) {
        i.value = 2;
      }

      if (decodedMessage.toString().contains("Forbidden")) {
        channel.sink.close();
      }
      if (decodedMessage.toString().contains("CALL_ENDED")) {
        channel.sink.close();

        i.value = Status.length - 1;
        end.value = true;

        Timer(Duration(seconds: 4), () {
          i.value = 0;
          end.value = false;
        });
      }

      print('DECODED MESSAFE $decodedMessage');
    }, onDone: () {
      debugPrint('ws channel closed');
    }, onError: (error) {
      // channel.sink.close();
      debugPrint('ws error $error');
    }, cancelOnError: true);
  }

  List<Widget> carouselItems = [
    Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Image.asset(
          'assets/search-png.png',
          height: 90,
          color: Colors.black,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'SEARCH',
          style: TextStyle(color: Colors.black),
        )
      ],
    ),
    Column(
      children: [
        Image.asset(
          'assets/call-png.png',
          height: 90,
          // scale: 0.1,
          color: Colors.black,
        ),
        //     Icon(Icons.call, size: 60, color: Colors.black),
        SizedBox(
          height: 20,
        ),
        Text(
          'CONNECT',
          style: TextStyle(color: Colors.black),
        )
      ],
    ),
    // Image.asset(
    //   'assets/call-png.png',
    //   color: Colors.black,
    // ),
    Column(
      children: [
        Image.asset(
          'assets/talk-png.png',
          height: 90,
          color: Colors.black,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'TALK',
          style: TextStyle(color: Colors.black),
        )
      ],
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserdetails();
  }

  getuserdetails() async {
    print("ewsz");
    await Api().getUserDetails();
    // await Api().getCurrentExpertDetails();
    //  await Api().getExpertDetails(User.consumerid);
    if (Api.getCurrentConsumerData.isNotEmpty) {
      setState(() {
        CurrentUser = Api.getCurrentConsumerData[0];
      });
    }
    print(
      "getCurrentConsumerData${CurrentUser}",
    );
    setState(() {
      showLoader = false;
    });
  }

  Future<void> signOutCurrentUser() async {
    try {
      await Amplify.Auth.signOut();
    } on AuthException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(mainAxisSize: MainAxisSize.min, children: [
            // Container(
            //   width: double.infinity,
            //   height: MediaQuery.sizeOf(context).height * 0.1,
            //   padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 15),
            //   decoration: BoxDecoration(
            //       color: Colors.black,
            //       borderRadius: BorderRadius.only(
            //           bottomLeft: Radius.circular(10),
            //           bottomRight: Radius.circular(10))),
            //   child: Container(
            //     child: Image.asset(
            //       "assets/anyquire-white.png",
            //       scale: 3.6,
            //     ),
            //   ),
            // ),

            Image.asset(
              'assets/anyquire-logoo.png',
              height: 130,
              width: 130,
            ),
            // SizedBox(
            //   height: 10,
            // ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: MediaQuery.sizeOf(context).width*0.01,),
                  Icon(
                    Icons.account_circle,
                    color: Textcolor,
                  ),
                  Text("  ${User.userPhonenumber}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            //  Spacer(),
            // Container(
            //   child: CarouselSlider(
            //     items: carouselItems,
            //     options: CarouselOptions(
            //       height: 150,
            //       autoPlay: true,
            //       autoPlayCurve: Curves.easeInToLinear,
            //       autoPlayAnimationDuration: Duration(milliseconds: 10),
            //       aspectRatio: 16 / 9,
            //     ),
            //   ),
            // ),

            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey)),
              margin: EdgeInsets.all(15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "  Corporate Info",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Browser("TERMS")));
                        },
                        child: Text(
                          "Terms of Use",
                          style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Browser("PRIVACY")));
                        },
                        child: Row(
                          children: [
                            Text(
                              "Privacy and Policy",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
            InkWell(
              onTap: () async {
                var res = await Api().initiateCall('+916366317466');
                print("ws resss: $res");
                websocketSubscribe();
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                        color: const Color.fromRGBO(158, 158, 158, 1))),
                margin: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.support_agent_rounded,
                          color: Textcolor,
                        ),
                        Text(
                          "  Request a call with support",
                          style: TextStyle(

                              // fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Blackcolor),
                        ),
                      ],
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(10.0),
                    //   child: Row(
                    //     children: [
                    //       Icon(
                    //         Icons.email_rounded,
                    //         color: Textcolor,
                    //       ),
                    //       Text(
                    //         "  contactus@anyquire.com",
                    //         style: TextStyle(
                    //           color: Colors.black,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Row(
                        children: [
                          // Icon(
                          //   Icons.call,
                          //   color: Textcolor,
                          // ),
                          // Text(
                          //   "  +91 - 6366317466",
                          //   style: TextStyle(color: Colors.black),
                          // ),
                        ],
                      ),
                    ),
                    //   Divider(),
                  ],
                ),
              ),
            ),
            // SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
            // Spacer(),
            GestureDetector(
              onTap: () async {
                print('TApped Exit');
                String title = "Delete account";
                String content =
                    "You will lose your existing credits in your wallet";

                var rs = await showDialogwithString(context, title, content);

                print("rssss:$rs");
                if (rs == "Yes") {
                  var res = await Api().updateUser("", "DELETE");
                  print("Response delete : $res");
                  signOutCurrentUser();
                  User().clear_user();
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.clear();
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 500),
                        pageBuilder: (_, __, ___) => LoginScreen(),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(0, 1),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                      ),
                      (route) => false);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                        color: const Color.fromRGBO(158, 158, 158, 1))),
                margin: EdgeInsets.all(15),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      Text(
                        "  Delete Account",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Container(
            //   alignment: Alignment.center,
            //   width: 400,
            //   height: 60,
            //   child: Text(
            //     textAlign: TextAlign.center,
            //     '2024 Mobil80 Services and Solutions Pvt Ltd\n All Rights Reserved.',
            //     style: TextStyle(color: Colors.white),
            //   ),
            //   decoration: BoxDecoration(
            //       color: Color.fromARGB(255, 76, 76, 76),
            //       borderRadius: BorderRadius.circular(4),
            //       border:
            //           Border.all(color: const Color.fromRGBO(158, 158, 158, 1))),
            //   margin: EdgeInsets.all(15),
            // ),

            Spacer(),

            Text("App Version 1.0.0"),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.02)
          ])),
    );
  }
}
