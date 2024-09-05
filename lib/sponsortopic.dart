import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:Anyquire/alertbox.dart';
import 'package:Anyquire/api.dart';
import 'package:Anyquire/main.dart';
import 'package:Anyquire/plans_and_pricing.dart';
import 'package:Anyquire/user.dart';
import 'package:Anyquire/userlogin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Sponsortopicdetails extends StatefulWidget {
  final item;
  const Sponsortopicdetails(this.item);

  @override
  State<Sponsortopicdetails> createState() => _SponsordetailsState();
}

class _SponsordetailsState extends State<Sponsortopicdetails> {
  
  RxInt i = 0.obs;
  RxBool end = false.obs;
  bool registeredUser = false;
  bool isAvailableToday = false;

  RxList Status = ['Connect', 'Initiating..', 'Connected', 'Ended'].obs;
  RxList<Color> buttonColors =
      [Textcolor, Textcolor, Colors.green, Colors.red].obs;
  RxBool is_server_maintanance = false.obs;
  bool expertbool = false;
  Map displayDetails = {};
  settings() async {
    var res = await Api().anyquiresettings();

    is_server_maintanance.value = res['is_server_on_maintainance'];

    print("server : $is_server_maintanance");
    log("settings res: ${res}");
  }

  getExpertDetails() async {
    print("objecttt");
    var res = await Api()
        .getExpertByDetailsByDisplayId(widget.item['sponsor_topic_display_id']);

    await Api().getUserDetails();

    log("RESULTTT: $res");
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
  }

  websocketSubscribe() async {
    print('wssss  consultantID: ${displayDetails['sponsor_topic_display_id']}');
    final wsUrl = Uri.parse(
        "wss://nru1pvaoib.execute-api.ap-south-1.amazonaws.com/Any/?anyquire_handle_id=${displayDetails['sponsor_topic_display_id']}");
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
  void initState() {
    settings();
    getExpertDetails();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          
        leading: BackButton(color: Textcolor,),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.75,
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            '${widget.item['sponsor_name_of_organization'].toString()}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        )
                    ,
                  //?? "${item['sponsor_topic_name_for_search'] ?? "${item['sponsor_name_of_organization']}
                  Text(
                    "${widget.item['sponsor_industry_sector_type'] ?? widget.item['sponsor_topic_name']}  ${widget.item['sponsor_type_of_organization'] ??""}",
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
        ),
        backgroundColor: Colors.white,
        body: (expertbool == true)
            ? Center(
                child: SpinKitFadingCircle(
                  size: 35,
                color: Textcolor,
              ))
            : Container(
                padding: EdgeInsets.all(15),
                height: screenSize.height,
                color: Colors.white,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        child: Row(children: [
                          displayDetails['sponsor_topic_logo'] != null
                              ? FutureBuilder(
                                  future: getPresignedUrlForPic(
                                      displayDetails['sponsor_topic_logo']),
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
                                            fit: BoxFit.cover,
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
                                                  fit: BoxFit.cover,
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
                                        print("displayDetail${User.userCredits}");
                                        print(
                                            '${widget.item['sponsor_topic_charge_per_min'].toString()}');
                                  
                                        if (double.parse(User.userCredits as String) <
                                            (widget.item[
                                                        'sponsor_topic_charge_per_min'] !=
                                                    0
                                                ? double.parse(
                                                    '${widget.item['sponsor_topic_charge_per_min'].toString()}')
                                                : 0)) {
                                          var a = await showDialogwithString(
                                              context,
                                              "Insufficient Balance",
                                              "Please recharge now");
                                          if (a == "Yes") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PlansAndPricing()));
                                          } else {
                                            Navigator.pop(context);
                                          }
                                        }
                                  
                                        i.value = 1;
                                  
                                        if (displayDetails['expert_phone_number'] ==
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
                                              "idddd: ${displayDetails['sponsor_topic_display_id']}");
                                                     if       (is_server_maintanance == false){
                                              
                                          var res = await Api().initiateCall(
                                              displayDetails[
                                                  'sponsor_topic_display_id']);
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
                                      },
                                      style: ElevatedButton.styleFrom(
                                        
                                          backgroundColor:  (is_server_maintanance == true)?Colors.grey: buttonColors[i.value],
                                          // (end == true) ? Colors.red : Bluecolor,
                                          foregroundColor: Colwhite,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          )),
                                      child:
                                  
                                          //  Text('${Status[index]}')
                                  
                                          Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
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
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
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
                        ]),
                        // Container(
                        //   width: MediaQuery.sizeOf(context).width * 0.6,
                        //   child: Text(
                        //     softWrap: true,
                        //     //sponsor_topic_description
                        //     "${widget.item['sponsor_topic_description'] ?? widget.item['sponsor_profile_description'] ?? ''}",
                        //     // overflow: TextOverflow.ellipsis,
                        //     style: TextStyle(
                        //         color: Colors.black, fontSize: 14),
                        //   ),
                        // )
                      ),
                          SizedBox(
              height: 20,
            ),
                      Container(
                        //   width: MediaQuery.sizeOf(context).width * 0.6,
                        child: Text(
                          softWrap: true,
                          //sponsor_topic_description
                          "${widget.item['sponsor_topic_description'] ?? widget.item['sponsor_profile_description'] ?? ''}",
                          // overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      )
                    ])));
  }
}
