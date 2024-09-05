import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:Anyquire/alertbox.dart';
import 'package:Anyquire/api.dart';
import 'package:Anyquire/main.dart';
import 'package:Anyquire/plans_and_pricing.dart';
import 'package:Anyquire/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Sponsordetail extends StatefulWidget {
  final item;

  const Sponsordetail(this.item);

  @override
  State<Sponsordetail> createState() => _SponsordetailState();
}

class _SponsordetailState extends State<Sponsordetail> {
   RxBool is_server_maintanance = false.obs;
  RxInt i = 0.obs;
  RxBool end = false.obs;
  Map displayDetails = {};
  bool registeredUser = false;
  bool isAvailableToday = false;
  RxList Status = ['Request a Call', 'Initiating..', 'Connected', 'Ended'].obs;
  RxList<Color> buttonColors =
      [Textcolor, Textcolor, Colors.green, Colors.red].obs;

  @override
  void initState() {
   // Api().anyquiresettings();
    settings();
    getExpertDetails();
    // boolCheckMethod();

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

    var res = await Api()
        .getExpertByDetailsByDisplayId(widget.item('sponsor_topic_display_id'));

    await Api().getUserDetails();

    log("available res: $res");
    if (res != "Error") {
      setState(() {
        displayDetails = res;
         isAvailableToday =
        displayDetails['expert_is_online'].toString() == "true" ? true : false;
         print("isAvailableToday $isAvailableToday");
      });
    }

    setState(() {
      // ConsumerCredit = sharedPreferences.getString("ConsumerCredit") ?? "";
      // print("credits here: ${User.userCredits}");
      //   expertbool = false;
    });
  }

  websocketSubscribe() async {
    print('wssss  consultantID: ${widget.item['sponsor_topic_display_id']}');
    final wsUrl = Uri.parse(
        "wss://nru1pvaoib.execute-api.ap-south-1.amazonaws.com/Any/?anyquire_handle_id=${widget.item['sponsor_topic_display_id']}");
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

  getPresignedUrlForPic(key) async {
    var tempUrl = await Api().getPresigneds3url(key);
    return tempUrl;
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
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Textcolor,),
        title: Row(
          children: [
            Text(
              '${widget.item['sponsor_topic_name']}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(15),
        child: Column(
          //    mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),

                widget.item['sponsor_topic_logo'] != null
                    ? FutureBuilder(
                        future: getPresignedUrlForPic(
                            widget.item['sponsor_topic_logo']),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              width: screenSize.width * 0.3,
                              height: screenSize.width * 0.3,
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
                                      width: screenSize.width * 0.3,
                                      height: screenSize.width * 0.3,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            screenSize.width * 0.1,
                                          ),
                                          child: Image.asset(
                                              'assets/LaunchLogo-aq.png')),
                                    );
                                  },
                                  imageUrl: "${snapshot.data}",
                                  fit: BoxFit.fill,
                                  imageBuilder: (context, ImageProvider) =>
                                      Container(
                                    height: MediaQuery.of(context).size.height *
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
                              width: screenSize.width * 0.3,
                              height: screenSize.width * 0.3,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    screenSize.width * 0.1,
                                  ),
                                  child:
                                      Image.asset('assets/LaunchLogo-aq.png')),
                            );
                          }
                        },
                      )
                    : Container(
                        width: screenSize.width * 0.3,
                        height: screenSize.width * 0.3,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              screenSize.width * 0.1,
                            ),
                            child: Image.asset('assets/LaunchLogo-aq.png')),
                      ),
                // Container(
                //   width: screenSize.width * 0.3,
                //   height: screenSize.width * 0.3,
                //   child: ClipRRect(
                //       borderRadius: BorderRadius.circular(
                //         screenSize.width * 0.1,
                //       ),
                //       child: Image.asset('assets/LaunchLogo-aq.png')),
                // ),
                SizedBox(
                  width: 40,
                ),
                
                          //  (!isAvailableToday)?SizedBox():
                Column(
                  children: [
                    Obx(() => 
                                   SizedBox(
                        width: 140,
                        child: ElevatedButton(
                            onPressed: () async {
                                   (is_server_maintanance == true)?
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
                                                                    fontSize: 16.0):
                              print("$registeredUser");
                              print("displadyDetail${User.userCredits}");
                              print('TOPICv CHARGE ${widget.item}');
                      
                              if (double.parse(User.userCredits as String) <
                                  double.parse(
                                      '${widget.item['sponsor_topic_charge_per_min'].toString()}')) {
                                var a = await showDialogwithString(context,
                                    "Insufficient Balance", "Please recharge now");
                                if (a == "Yes") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PlansAndPricing()));
                                } else {
                                  Navigator.pop(context);
                                }
                              }
                      
                              i.value = 1;
                      
                              if (widget.item['sponsor_topic_display_id'] ==
                                  User.userPhonenumber) {
                                Fluttertoast.showToast(
                                    msg: "You can't call yourself",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP_LEFT,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Textcolor,
                                    textColor: Colwhite,
                                    fontSize: 16.0);
                              } else {
                                print(
                                    "idddd: ${widget.item['sponsor_topic_display_id']}");
                                       if       (is_server_maintanance == false){
                                var res = await Api().initiateCall(
                                    widget.item['sponsor_topic_display_id']);
                                print("ws resss: $res");
                      
                                if (res == "Error") {
                                  i.value = 0;
                                  Fluttertoast.showToast(
                                      msg: "Something went wrong",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.TOP_LEFT,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Textcolor,
                                      textColor: Colwhite,
                                      fontSize: 16.0);
                                }
                                websocketSubscribe();
                              }else{
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
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:(is_server_maintanance == true)?Colors.grey: buttonColors[i.value],
                                // (end == true) ? Colors.red : Bluecolor,
                                foregroundColor: Colwhite,
                                padding:
                                    EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )),
                            child:
                      
                                //  Text('${Status[index]}')
                      
                                Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                  Icon(
                                    Icons.call_outlined,
                                    size: 20,
                                  ),
                                     (is_server_maintanance == true)?
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
                                    Status[i.value] == "Connect"
                                        ? "  Request a Call"
                                        : '  ${Status[i.value]}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                ]
                                    //( Icons.call_outlined)],
                                    )),
                                    
                      ),
                    ),
                  Text(
                                          
                                          (widget.item['sponsor_topic_charge_per_min'] ??
                                                      0) >
                                                  0
                                              ? "FREE for the 1st minute, \n \u20B9${widget.item['sponsor_topic_charge_per_min']}/min thereafter"
                                              : "FREE",style: TextStyle( fontSize: 12,
                                            fontWeight: FontWeight.bold),)
                  ],
                )
               
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text('${widget.item['sponsor_topic_description']}')
          ],
        ),
      ),
    );
  }
}
