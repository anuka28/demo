import 'dart:developer';

import 'package:Anyquire/api.dart';
import 'package:Anyquire/detail_sponsor.dart';
import 'package:Anyquire/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Sponsor extends StatefulWidget {
  final item;
  const Sponsor(this.item);

  @override
  State<Sponsor> createState() => _SponsorState();
}

class _SponsorState extends State<Sponsor> {
  RxBool is_server_maintanance = false.obs;
  bool expertbool = false;
  Map displayDetails = {};
  List topics = [];

  settings() async {
    var res = await Api().anyquiresettings();

    is_server_maintanance.value = res['is_server_on_maintainance'];

    print("server : $is_server_maintanance");
    log("settings res: ${res}");
  }

  getExpertDetails() async {
    setState(() {
      expertbool = true;
    });
    print("objecttt");
    var res = await Api()
        .getExpertByDetailsByDisplayId(widget.item['sponsor_display_id']);

    await Api().getUserDetails();

    log("available res: $res");

    topics = res['topics'];
    print("topicss: $topics");
    if (res != "Error") {
      topics = res['topics'];
      // setState(() {
      //   displayDetails = res;
      //   isAvailableToday =
      //       displayDetails['expert_is_online'].toString() == "true"
      //           ? true
      //           : false;
      //   print("isAvailableToday $isAvailableToday");
      // });
    }
    setState(() {
      expertbool = false;
    });
  }

  getPresignedUrlForPic(key) async {
    var tempUrl = await Api().getPresigneds3url(key);
    return tempUrl;
  }

  @override
  void initState() {
    settings();
    getExpertDetails();
    print('qwerty${widget.item['sponsor_topic_logo']}');

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          
        leading: BackButton(color: Textcolor,),
          surfaceTintColor: Colors.transparent,
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
                            '${widget.item['sponsor_name_of_organization']}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                
                  //?? "${item['sponsor_topic_name_for_search'] ?? "${item['sponsor_name_of_organization']}
                  Text(
                    "${widget.item['sponsor_type_of_organization'] ?? ""},  ${widget.item['sponsor_industry_sector_type'] ?? ""}",
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
                padding: EdgeInsets.all(10),
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
                            widget.item['sponsor_logo'] != null
                                ? FutureBuilder(
                                    future: getPresignedUrlForPic(
                                        widget.item['sponsor_logo']),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Container(
                                          width: screenSize.width * 0.25,
                                          height: screenSize.width * 0.25,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      screenSize.width *
                                                          0.25)),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              screenSize.width * 0.25,
                                            ),
                                            child: CachedNetworkImage(
                                              errorWidget:
                                                  (context, url, error) {
                                                return Container(
                                                  width:
                                                      screenSize.width * 0.25,
                                                  height:
                                                      screenSize.width * 0.25,
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        screenSize.width * 0.25,
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
                                              borderRadius:
                                                  BorderRadius.circular(
                                                screenSize.width * 0.25,
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
                              width: 10,
                            ),
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.6,
                              child: Text(
                                softWrap: true,
                                //sponsor_topic_description
                                "${widget.item['sponsor_topic_description'] ?? widget.item['sponsor_profile_description'] ?? ''}",
                                // overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                            )
                          ])),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Topics:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                     
                      Container(
                       height: MediaQuery.sizeOf(context).height *0.66,
                        child: ListView.builder(
                            itemCount: topics.length,
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              log(topics.toString());
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Sponsordetail(topics[index])));
                                },
                                child: Container(
                                  margin: EdgeInsets.all(4),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color:  Color.fromARGB(255, 242, 242, 242),
                                    //   borderRadius: BorderRadius.circular(6)
                                  ),
                                  child: Container(
                                    width: screenSize.width * 0.2,
                                 //   height: screenSize.width * 0.5,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        topics[index]['sponsor_topic_logo'] !=
                                                null
                                            ? FutureBuilder(
                                                future: getPresignedUrlForPic(
                                                    topics[index]
                                                        ['sponsor_topic_logo']),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Container(
                                                      width: screenSize.width *
                                                          0.15,
                                                      height: screenSize.width *
                                                          0.15,

                                                      child: ClipRRect(
                                                        child:
                                                            CachedNetworkImage(
                                                          errorWidget: (context,
                                                              url, error) {
                                                            return Container(
                                                              width: screenSize
                                                                      .width *
                                                                  0.1,
                                                              height: screenSize
                                                                      .width *
                                                                  0.1,
                                                              child: ClipRRect(
                                                                  child: Image
                                                                      .asset(
                                                                          'assets/LaunchLogo-aq.png')),
                                                            );
                                                          },
                                                          imageUrl:
                                                              "${snapshot.data}",
                                                          fit: BoxFit.fill,
                                                          imageBuilder: (context,
                                                                  ImageProvider) =>
                                                              Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.14,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    ImageProvider,
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return Container(
                                                      width: screenSize.width *
                                                          0.15,
                                                      height: screenSize.width *
                                                          0.15,
                                                      child: ClipRRect(
                                                          child: Image.asset(
                                                              'assets/LaunchLogo-aq.png')),
                                                    );
                                                  }
                                                },
                                              )
                                            : Container(
                                                width: screenSize.width * 0.15,
                                                height: screenSize.width * 0.15,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      screenSize.width * 0.1,
                                                    ),
                                                    child: Image.asset(
                                                        'assets/LaunchLogo-aq.png')),
                                              ),

                                        //                       Container(
                                        //   width: screenSize.width * 0.15,
                                        //   height: screenSize.width * 0.15,
                                        //   child: ClipRRect(
                                        //       borderRadius:
                                        //           BorderRadius.circular(
                                        //         screenSize.width * 0.1,
                                        //       ),
                                        //       child: Image.asset(
                                        //           'assets/LaunchLogo-aq.png')),
                                        // ),

                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${topics[index]['sponsor_topic_name']}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,),
                                            ),
                                            SizedBox(
                                              width: screenSize.width * 0.7,
                                              //height: screenSize.width * 1,

                                              child: Text(
                                                  '${topics[index]['sponsor_topic_description']}'),
                                            ),
                                          ],
                                        ),
                                        // SizedBox(
                                        //   height: 150,
                                        // )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
                      //list view topics
                    ])));
  }
}
