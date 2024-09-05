import 'dart:async';

import 'package:Anyquire/alertbox.dart';
import 'package:Anyquire/api.dart';

import 'package:Anyquire/main.dart';
import 'package:Anyquire/plans_and_pricing.dart';
import 'package:Anyquire/user.dart';
import 'package:Anyquire/userlogin.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AbtConslt extends StatefulWidget {
  final consultantDisplayId;

  const AbtConslt(this.consultantDisplayId);

  @override
  _AbtConsltState createState() => _AbtConsltState();
}

class _AbtConsltState extends State<AbtConslt> {
  RxBool is_server_maintanance = false.obs;

  // final WebSocketChannel channel = IOWebSocketChannel.connect(
  //     'wss://nru1pvaoib.execute-api.ap-south-1.amazonaws.com/Any/?expert_email_id=expert_email_id');

  RxList Status = ['Connect', 'Initiating..', 'Connected', 'Ended'].obs;

  RxList<Color> buttonColors =
      [Textcolor, Textcolor, Colors.green, Colors.red].obs;
  RxInt i = 0.obs;
  String review = "";
  RxBool end = false.obs;
  bool isAvailableToday = false;
  bool expertbool = true;
  bool registeredUser = false;
  Map displayDetails = {};
  bool callCheck = false;
  RxList<TableRow> availableHoursDaily = <TableRow>[].obs;

  getPresignedUrlForPic(key) async {
    var tempUrl = await Api().getPresigneds3url(key);
    return tempUrl;
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return '';
    }
    return text[0].toUpperCase() + text.substring(1);
  }

  boolCheckMethod() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    //  bool FirstTime = sharedPreferences.getBool('initialLogin') ?? true;

    bool AlreadyLoggedin = await sharedPreferences.getBool('loggedin') ?? false;

    setState(() {
      // initialLogin = FirstTime;
      registeredUser = AlreadyLoggedin;
      print('$registeredUser');
    });
  }

  @override
  void initState() {
    settings();
    getExpertDetails();
    boolCheckMethod();

    // TODO: implement initState
    super.initState();
  }

  settings() async {
    var res = await Api().anyquiresettings();

    is_server_maintanance.value = res['is_server_on_maintainance'];

    print("server : $is_server_maintanance");
    log("settings res: ${res}");
  }

  getExpertDetails() async {
    print("objecttt");

    var res =
        await Api().getExpertByDetailsByDisplayId(widget.consultantDisplayId);

    await Api().getUserDetails();

    log("available res: $res");
    if (res != "Error") {
      setState(() {
        displayDetails = res;
        isAvailableToday =
            displayDetails['expert_is_online'].toString() == "true"
                ? true
                : false;
        print("isAvailableToday $isAvailableToday");
      });
    }

    setState(() {
      // ConsumerCredit = sharedPreferences.getString("ConsumerCredit") ?? "";
      // print("credits here: ${User.userCredits}");
      expertbool = false;
    });
  }

  websocketSubscribe() async {
    print('wssss  consultantID: ${displayDetails['expert_display_id']}');
    final wsUrl = Uri.parse(
        "wss://nru1pvaoib.execute-api.ap-south-1.amazonaws.com/Any/?anyquire_handle_id=${displayDetails['expert_display_id']}");
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

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                (expertbool == false)
                    ? SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.75,
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          '${displayDetails['expert_name'].toString()}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : SizedBox(),
                if (displayDetails['expert_state'] != null)
                  Text(
                    " ${capitalizeFirstLetter(displayDetails['expert_state'])}, ${capitalizeFirstLetter(displayDetails['expert_country'])}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  
              ],
            ),
          ],
        ),

        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,

        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         callFeedback();
        //       },
        //       icon: Icon(Icons.rate_review))
        // ],
        //   backgroundColor: Textcolor,

          leading: BackButton(color: Textcolor),
      ),

      body: (expertbool == true)
          ? Center(
              child: SpinKitFadingCircle(
                size: 35,
              color: Textcolor,
            ))
          : Container(
              height: screenSize.height,
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row(
                        //   children: [
                        //     Icon(
                        //       Icons.person,
                        //       color: Textcolor,
                        //     ),
                        //     Text(
                        //       //   overflow: TextOverflow.ellipsis,
                        //       ' ${displayDetails['expert_name'].toString()}',
                        //       style: TextStyle(
                        //         fontSize: 18,
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.black,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(
                        //   height: 2,
                        // ),
                        // if (displayDetails['expert_state'] != null)
                        //   Row(
                        //     children: [
                        //       Icon(
                        //         Icons.location_on,
                        //         color: Textcolor,
                        //       ),
                        //       Text(
                        //         " ${capitalizeFirstLetter(displayDetails['expert_state'])},${capitalizeFirstLetter(displayDetails['expert_country'])}",
                        //         style: TextStyle(
                        //           fontSize: 14,
                        //           color: Colors.black,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Row(
                      children: [
                        displayDetails['expert_profile_pic_url'] != null
                            ? FutureBuilder(
                                future: getPresignedUrlForPic(
                                    displayDetails['expert_profile_pic_url']),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Container(
                                      width: screenSize.width * 0.25,
                                      height: screenSize.width * 0.25,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              screenSize.width * 0.125)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          screenSize.width * 0.125,
                                        ),
                                        child: CachedNetworkImage(
                                          errorWidget: (context, url, error) {
                                            return Container(
                                              width: screenSize.width * 0.25,
                                              height: screenSize.width * 0.25,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    screenSize.width * 0.1,
                                                  ),
                                                  child: Image.asset(
                                                      'assets/LaunchLogo-aq.png')),
                                            );
                                          },
                                          imageUrl: "${snapshot.data}",
                                          fit: BoxFit.fill,
                                          imageBuilder:
                                              (context, ImageProvider) =>
                                                  Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.14,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: ImageProvider,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      width: screenSize.width * 0.25,
                                      height: screenSize.width * 0.25,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            screenSize.width * 0.1,
                                          ),
                                          child: Image.asset(
                                              'assets/LaunchLogo-aq.png')),
                                    );
                                  }
                                },
                              )
                            : Container(
                                width: screenSize.width * 0.25,
                                height: screenSize.width * 0.25,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      screenSize.width * 0.1,
                                    ),
                                    child: Image.asset(
                                        'assets/LaunchLogo-aq.png')),
                              ),
                        SizedBox(
                          width: 30,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: MediaQuery.sizeOf(context).width * 0.6,
                                  child:
                                      (displayDetails['expert_service_name'] !=
                                              null)
                                          ? Text(
                                              "${displayDetails['expert_service_name'].toString()}",
                                              // overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),
                                            )
                                          : SizedBox()),
                              // SizedBox(
                              //   height: 5,
                              // ),
                              // Text(
                              //   "\u20B9${displayDetails['expert_charge_per_minute']}/min",
                              //   style: TextStyle(
                              //       fontSize: 12.5,
                              //       fontWeight: FontWeight.w600,
                              //       color: Colors.black),
                              // ),
                              SizedBox(
                                height: 10,
                              ),
                              (!isAvailableToday)
                                  ? SizedBox()
                                  : Obx(
                                      () => Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
                                              color: Colors.transparent,
                                              child: SizedBox(
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                            .height *
                                                        0.05,
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.44,
                                                child: ElevatedButton(
                                                    onPressed: ()
                                                     async {
                                                      (is_server_maintanance == true)?
                                                             Fluttertoast.showToast(
                                                                msg:
                                                                    "Under maintenance - Sorry for the inconvenience",
                                                                toastLength: Toast
                                                                    .LENGTH_LONG,
                                                                gravity:
                                                                    ToastGravity
                                                                        .TOP_LEFT,
                                                                timeInSecForIosWeb:
                                                                    1,
                                                                backgroundColor:
                                                                    Textcolor,
                                                                textColor:
                                                                    Colwhite,
                                                                fontSize: 16.0):
                                                  
                                                      print("$registeredUser");
                                                      print(
                                                          "displayDetail${User.userCredits}");
                                                      if (registeredUser) {
                                                        if (double.parse(
                                                                User.userCredits
                                                                    as String) <
                                                            double.parse(
                                                                '${displayDetails['expert_charge_per_minute'].toString()}')) {
                                                          var a = await showDialogwithString(
                                                              context,
                                                              "Insufficient Balance",
                                                              "Please recharge now");
                                                          if (a == "Yes") {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            PlansAndPricing()));
                                                          } else {
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        }
                                                   

                                                        i.value = 1;

                                                        if (displayDetails[
                                                                'expert_phone_number'] ==
                                                            User.userPhonenumber) {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "You can't call yourself",
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .TOP_LEFT,
                                                              timeInSecForIosWeb:
                                                                  1,
                                                              backgroundColor:
                                                                Textcolor,
                                                              textColor:
                                                                  Colwhite,
                                                              fontSize: 16.0);
                                                        } else {
                                                          print(
                                                              "idddd: ${displayDetails['expert_display_id']}");
                                                        if       (is_server_maintanance == false){
                                                          
                                                              
                                                          var res = await Api()
                                                              .initiateCall(
                                                                  displayDetails[
                                                                      'expert_display_id']);
                                                          print(
                                                              "ws resss: $res");

                                                          if (res == "Error") {
                                                            i.value = 0;
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Something went wrong",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .TOP_LEFT,
                                                                timeInSecForIosWeb:
                                                                    1,
                                                                backgroundColor:
                                                                    Textcolor,
                                                                textColor:
                                                                    Colwhite,
                                                                fontSize: 16.0);
                                                          }
                                                          websocketSubscribe();
                                                        }
                                                        else{
                                                                           Fluttertoast.showToast(
                                                                msg:
                                                                    "Under maintenance - Sorry for the inconvenience",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .TOP_LEFT,
                                                                timeInSecForIosWeb:
                                                                    1,
                                                                backgroundColor:
                                                                    Textcolor,
                                                                textColor:
                                                                    Colwhite,
                                                                fontSize: 16.0);
                                                        }
                                                        }
                                                              
                                                  

                                                        // setState(() {});
                                                        // Future.delayed(Duration(seconds: 5), () {
                                                        //   print("after 5 seconds");
                                                        //   setState(() {
                                                        //     callCheck = false;
                                                        //   });
                                                        // });
                                                      } 
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                            (is_server_maintanance == true)?Colors.grey:
                                                                buttonColors[i
                                                                    .value],
                                                            // (end == true) ? Colors.red : Bluecolor,
                                                            foregroundColor:
                                                                Colwhite,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        1,
                                                                    vertical:
                                                                        1),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            )),
                                                    child:

                                                        //  Text('${Status[index]}')

                                                        Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                          Icon(
                                                            Icons.call_outlined,
                                                            size: 15,
                                                          ),
                                                                (is_server_maintanance == true || (displayDetails[
                                                                'expert_phone_number'] ==
                                                            User.userPhonenumber))?
                                                                  Text(
                                                         "  Request a Call",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ):

                                                          Text(
                                                            Status[i.value] ==
                                                                    "Connect"
                                                                ? "  Request a Call"
                                                                : '  ${Status[i.value]}',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ]
                                                            //( Icons.call_outlined)],
                                                            )),
                                              ),
                                            ),
                                    ),
                              (displayDetails['expert_charge_type'] ==
                                      'FREMIUM')
                                  ? SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.6,
                                      child: Text(
                                        'FREE for the 1st minute, \u20B9${displayDetails['expert_charge_per_minute']}/min thereafter',
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : SizedBox()
                            ]),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.01,
                  ),
                  (!isAvailableToday)
                      ? Text(
                          "     Not available to take calls",
                          style: TextStyle(fontSize: 14, color: Colors.red),
                        )
                      : SizedBox(),
                  if (displayDetails['expert_charge_per_minute'] != null)
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.56,
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.001),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 10),
                          //   child: Card(
                          //     color: Colors.white,
                          //     elevation: 0,
                          //     child: Container(
                          //       padding: const EdgeInsets.all(5.0),
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Row(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.start,
                          //             children: [
                          //               SizedBox(
                          //                 width: 10,
                          //               ),
                          //               Text(
                          //                 'Experience',
                          //                 style: TextStyle(
                          //                   fontSize: 16,
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //           Divider(
                          //             color: Colors.grey.shade400,
                          //             thickness: 0.5,
                          //           ),
                          //           if (displayDetails['expert_experience'] !=
                          //               null)
                          //             Text(
                          //                 "   ${displayDetails['expert_experience']} Years")
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          Card(
                            color: Colors.white,
                            elevation: 0,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Languages spoken',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Divider(
                                  //   color: Colors.grey.shade400,
                                  //   thickness: 0.5,
                                  // ),
                                  if (displayDetails['expert_languages'] !=
                                      null)
                                    Container(
                                         padding:
                                                  const EdgeInsets.only(left: 10,),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      width:
                                          MediaQuery.of(context).size.width,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,

                                          
                                          shrinkWrap: true,
                                          itemCount: displayDetails[
                                                  'expert_languages']
                                              .length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(2),
                                              child: Chip(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                side: BorderSide(
                                                  color: const Color.fromARGB(
                                                      255, 243, 242, 242),
                                                ),
                                                backgroundColor:
                                                    Color.fromARGB(
                                                        255, 244, 243, 243),
                                                label: Text(
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                  "${displayDetails['expert_languages'][index]}",
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Card(
                              color: Colors.white,
                              elevation: 0,
                              // height: screenSize.height * 0.45,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                       
                                       
                                          Text(
                                            'Description of services offered',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Divider(
                                      //   color: Colors.grey.shade400,
                                      //   thickness: 0.5,
                                      // ),
                                      Text(
                                        textAlign: TextAlign.start,
                                        "${displayDetails['expert_long_description']}",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      SizedBox(height: 10),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
      // bottomNavigationBar: InkWell(
      //   onTap: () {},
      //   child: Container(
      //     height: 60,
      //     color: Colors.blueGrey[200],
      //     padding: EdgeInsets.symmetric(vertical: 15),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Text(
      //           'Call',
      //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //         ),
      //         SizedBox(width: 10),
      //         Icon(Icons.call, size: 20, color: Bluecolor),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
