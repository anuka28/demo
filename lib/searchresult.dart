import 'dart:convert';
import 'dart:developer';

import 'package:Anyquire/alertbox.dart';
import 'package:Anyquire/api.dart';
import 'package:Anyquire/expertdetails.dart';

import 'package:Anyquire/main.dart';
import 'package:Anyquire/sponsor.dart';
import 'package:Anyquire/sponsortopic.dart';
import 'package:Anyquire/user.dart';
import 'package:Anyquire/usersearch.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SearchResult extends StatefulWidget {
  final search;
  const SearchResult(this.search, {super.key});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  final WebSocketChannel channel = IOWebSocketChannel.connect(
      'wss://nru1pvaoib.execute-api.ap-south-1.amazonaws.com/Any/?expert_email_id=expert_email_id');

  List status = ['initiating', 'connecting', 'ringing', 'ended'];

  String Call_not_started = "";
  List callLog = [];
  bool registeredUser = false;
  bool callCheck = false;
  bool showLoader = false;
  TextEditingController searchController = TextEditingController();
  String searchkey = "Search";
  bool showcancel_icon = false;
  @override
  void initState() {
    
    searchController.text = widget.search;
    // boolCheckMethod();
    super.initState();
  }

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

  websocketSubscribe(expert_id) {
    print(
        'wssss ${"wss://nru1pvaoib.execute-api.ap-south-1.amazonaws.com/Any/?expert_id=$expert_id"}');
    final wsUrl = Uri.parse(
        "wss://nru1pvaoib.execute-api.ap-south-1.amazonaws.com/Any/?expert_email_id=$expert_id");
    var channel = WebSocketChannel.connect(wsUrl);

    channel.stream.listen(
      (message) async {
        log(message);
        var msg = jsonDecode(message);
        print('Message got : ${msg}');
        Call_not_started = msg['message'];

        print(' Message is  ${Call_not_started}');
        setState(() {
          Call_not_started = msg;
        });

        channel.sink.add('received!');

        channel.sink.close();
        final decodedMessage = await json.decode(message);
        print(decodedMessage);
      },
      onDone: () {
        debugPrint('ws channel closed');
      },
      onError: (error) {
        debugPrint('ws error $error');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      extendBody: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: BackButton(color: Textcolor),
        elevation: 0,
        title: Container(
          height: 60,
          child: Image.asset('assets/anyquire-logoo.png', scale: 1),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          height: screenSize.height,
          width: screenSize.width,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height*0.01,
              ),
              Hero(
                tag: searchkey,
                transitionOnUserGestures: true,
                child: Center(
                  child: Material(
                    color: Colors.transparent,
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      cursorColor: Textcolor,
                      controller: searchController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        constraints: BoxConstraints.loose(Size(
                            MediaQuery.of(context).size.width * 0.94,
                            MediaQuery.of(context).size.height * 0.07)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Blackcolor),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Blackcolor),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Blackcolor),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        hintText: "Search by keywords",
                    //    hintText: "Search for a Provider",
                        hintStyle: TextStyle(color: Colors.black45),
                        suffixIcon: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Spacer(),
                            (searchController.text == "")
                                ? SizedBox()
                                                         :InkWell(
                                  onTap: (){
                                           setState(() {
                                        searchController.text = "";
                                      });

                                      searchController.clear();
                         
                                    
                                  },
                                  
                                  child: Icon(Icons.close, )),
                                     SizedBox(width: MediaQuery.sizeOf(context).width*0.01),

                                  InkWell(
                                    onTap: () async{
                                      FocusManager.instance.primaryFocus!.unfocus();
                                  if (searchController.text.isNotEmpty) {
                                    print('QWERTYUIOP');
                                    setState(() {
                                      showLoader = true;
                                    });
                                    await Api()
                                        .openSearchForConsultant(searchkey);

                                    setState(() {
                                      showLoader = false;
                                    });
                                    (searchController.text.isNotEmpty)
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SearchResult(
                                                        searchController
                                                            .text))).then(
                                            (value) => searchController.clear()): Icon(Icons.search_rounded);
                                  }

                                      
                                    },
                                    
                                    child: Icon(Icons.search_rounded)),
                                    SizedBox(width: 10,)
                            //     : IconButton(
                            //         onPressed: () {
                            //           setState(() {
                            //             searchController.text = "";
                            //           });

                            //           searchController.clear();
                            //         },
                            //         icon: Icon(Icons.cancel)),
                            // IconButton(
                            //     onPressed: () async {
                            //       FocusManager.instance.primaryFocus!.unfocus();
                            //       if (searchController.text.isNotEmpty) {
                            //         print('QWERTYUIOP');
                            //         setState(() {
                            //           showLoader = true;
                            //         });
                            //         await Api()
                            //             .openSearchForConsultant(searchkey);

                            //         setState(() {
                            //           showLoader = false;
                            //         });
                            //         (searchController.text.isNotEmpty)
                            //             ? Navigator.push(
                            //                 context,
                            //                 MaterialPageRoute(
                            //                     builder: (context) =>
                            //                         SearchResult(
                            //                             searchController
                            //                                 .text))).then(
                            //                 (value) => searchController.clear())
                            //             : Icon(Icons.search);
                            //       }
                            //     },
                            //     icon: Icon(Icons.search)),
                          ],
                        ),
                        suffixIconColor: Colors.black45,
                      ),
                      onTap: () {
                        setState(() {
                          showcancel_icon = searchController.text.isNotEmpty;
                        });
                      },
                      onFieldSubmitted: (val) async {
                        setState(() {
                          showLoader = true;
                        });
                        await Api()
                            .openSearchForConsultant(searchController.text);
                        setState(() {
                          showLoader = false;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 0.01,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: keywordsList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.blueGrey.shade100,
                          borderRadius: BorderRadius.circular(6)),
                      padding: EdgeInsets.all(7),
                      margin: EdgeInsets.all(5),
                      child: InkWell(
                          onTap: () async {
                            setState(() {
                              showLoader = true;
                            });
                            FocusManager.instance.primaryFocus!.unfocus();
                            await Api()
                                .openSearchForConsultant(keywordsList[index]);

                            setState(() {
                              searchController.text = keywordsList[index];
                              showLoader = false;
                            });
                          },
                          child: Text("${keywordsList[index]}")),
                    );
                  },
                ),
              ),
              (showLoader == true)
                  ? SpinKitFadingCircle(
                    size: 35,
                      color: Textcolor,
                    )
                  : SizedBox(),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  child: Api.openSearcResult.isNotEmpty
                      ? ListView.builder(
                          itemCount: Api.openSearcResult.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var item = Api.openSearcResult[index]['_source'];
                         
                              print('expert_service_name  ${item['expert_service_name']}');
                            print('topic  ${item['sponsor_topic_name']}');
                            print("open search item : $item");
                           
                              print('org ${item['sponsor_name_of_organization']}');
                            
                         

                            return InkWell(
                              onTap: () {
                                
                                log("item item :${item['expert_display_id']}");
                                print(
                                    "sponsor item: ${item['sponsor_display_id']}");

                                if (item['search_type'] == 'SPONSOR_TOPIC')
                                //    if (item['expert_display_id'] != null)
                                {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Sponsortopicdetails(
                                              item
                                              // item['expert_display_id']
                                              // ??
                                              // item['sponsor_display_id'] ??
                                              // item['sponsor_topic_display_id']
                                              )));
                                } else if (item['search_type'] == 'SPONSOR') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Sponsor(item
                                              // item['expert_display_id']
                                              // ??
                                              // item['sponsor_display_id'] ??
                                              // item['sponsor_topic_display_id']
                                              )));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AbtConslt(
                                              item['expert_display_id']
                                              // ??
                                              // item['sponsor_display_id'] ??
                                              // item['sponsor_topic_display_id']
                                              )));
                                }
                              },
                              child: Container(
                                
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                //  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromARGB(255, 242, 242, 242),
                                ),
                                // padding: EdgeInsets.all(10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          // width:
                                          //     MediaQuery.sizeOf(context).width *
                                          //         0.5,
                                          child: Row(
                                            children: [
                                              ((item['expert_profile_pic_url'] !=
                                                          null) ||
                                                      (item['sponsor_logo'] !=
                                                          null) ||
                                                      (item['sponsor_topic_logo'] !=
                                                          null))
                                                  ? FutureBuilder(
                                                      future: getPresignedUrlForPic((item[
                                                                  'search_type'] ==
                                                              'EXPERT')
                                                          ? item[
                                                              'expert_profile_pic_url']
                                                          : item['search_type'] ==
                                                                  'SPONSOR'
                                                              ? item[
                                                                  'sponsor_logo']
                                                              : item[
                                                                  'sponsor_topic_logo']),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          return Container(
                                                            width: screenSize
                                                                    .width *
                                                                0.1,
                                                            height: screenSize
                                                                    .width *
                                                                0.1,
                                                            child: ClipRRect(
                                                              child:
                                                                  CachedNetworkImage(
                                                                errorWidget:
                                                                    (context,
                                                                        url,
                                                                        error) {
                                                                  return Container(
                                                                    width: screenSize
                                                                            .width *
                                                                        0.1,
                                                                    height:
                                                                        screenSize.width *
                                                                            0.1,
                                                                    child: ClipRRect(
                                                                        child: Image.asset(
                                                                            'assets/LaunchLogo-aq.png')),
                                                                  );
                                                                },
                                                                imageUrl:
                                                                    "${snapshot.data}",
                                                                fit:
                                                                    BoxFit.fill,
                                                                imageBuilder:
                                                                    (context,
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
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        } else {
                                                          return Container(
                                                            width: screenSize
                                                                    .width *
                                                                0.1,
                                                            height: screenSize
                                                                    .width *
                                                                0.1,
                                                            child: ClipRRect(
                                                                child: Image.asset(
                                                                    'assets/LaunchLogo-aq.png')),
                                                          );
                                                        }
                                                      },
                                                    )
                                                  : Container(
                                                      width: screenSize.width *
                                                          0.1,
                                                      height: screenSize.width *
                                                          0.1,
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            screenSize.width *
                                                                0.1,
                                                          ),
                                                          child: Image.asset(
                                                              'assets/LaunchLogo-aq.png')),
                                                    ),
                                                    SizedBox(width: 10,),
                                              SizedBox(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.59,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    (item['search_type'] == 'SPONSOR_TOPIC')?
                                                    Text( " ${item['sponsor_topic_name']}",
                                                  
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                  
                                                      style: TextStyle(
                                                          color: Textcolor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ):(item['search_type'] == 'EXPERT')? Text("${item['expert_service_name']}",style: TextStyle(
                                                      //  overflow:
                                                          // TextOverflow.ellipsis,
                                                          color: Textcolor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),):Text(" ${item['sponsor_name_of_organization'] }",style: TextStyle(
                                                          color: Textcolor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),),
                                                    (item['expert_service_name'] ==
                                                            null)
                                                        ? SizedBox(
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width *
                                                                0.6,
                                                            child: Text(
                                                                style: TextStyle(
                                                                  
                                                                    fontSize:
                                                                        10),
                                                                "  ${item['sponsor_type_of_organization'] ?? "${item['sponsor_name_of_organization']}"} ${item['sponsor_industry_sector_type'] == null ? "" : ",${item['sponsor_industry_sector_type']}"} "),
                                                          )
                                                        : SizedBox()
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // if (item['expert_last_name'] !=
                                        //         null &&
                                        //     item['expert_last_name'].trim() !=
                                        //         "")
                                        //   Text(
                                        //     "${capitalizeFirstLetter(item['expert_last_name'])} ",
                                        //     style: TextStyle(
                                        //         color: Bluecolor,
                                        //         fontSize: 16,
                                        //         fontWeight: FontWeight.bold),
                                        //   ),
                                        Spacer(),
                                        (item['search_type'] == 'EXPERT')?
                                        Text(
                                          
                                          (item['expert_charge_per_minute'] ??
                                                      0) >
                                                  0
                                              ? "\u20B9${item['expert_charge_per_minute']}/min"
                                              : "FREE",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black
                                              // Color.fromARGB(255, 131, 69, 215),
                                              ),
                                        ):   (item['search_type'] == 'SPONSOR_TOPIC')?     Text(
                                          
                                          (item['sponsor_topic_charge_per_min'] ??
                                                      0) >
                                                  0
                                              ? "\u20B9${item['sponsor_topic_charge_per_min']}/min"
                                              : "FREE",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black
                                              // Color.fromARGB(255, 131, 69, 215),
                                              ),
                                        ) : Text(''),
                                      ],
                                    ),

                                    SizedBox(height: 7),
                                    if (item['expert_languages'] != null)
                                      Wrap(
                                        children: [
                                          for (int f = 0;
                                              f <
                                                  item['expert_languages']
                                                      .replaceAll('[', '')
                                                      .replaceAll(']', '')
                                                      .split(',')
                                                      .length;
                                              f++)
                                            Container(
                                              width: item['expert_languages']
                                                      .replaceAll('[', '')
                                                      .replaceAll(']', '')
                                                      .split(',')[f]
                                                      .replaceAll('"', '')
                                                      .length *
                                                  11.toDouble(),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade300,
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 6, vertical: 1),
                                              margin: EdgeInsets.only(
                                                  right: 8, bottom: 4),
                                              child: Text(
                                                style: TextStyle(fontSize: 11),
                                                "${item['expert_languages'].replaceAll('[', '').replaceAll(']', '').split(',')[f].replaceAll('"', '')}",
                                              ),
                                            )
                                        ],
                                      ),
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       "${capitalizeFirstLetter(item['expert_state'] ?? "")} ",
                                    //       style: TextStyle(
                                    //           color: Colors.grey,
                                    //           fontSize: 12,
                                    //           fontWeight: FontWeight.bold),
                                    //     ),
                                    //     Text(
                                    //       "${capitalizeFirstLetter(item['expert_country'] ?? "")}  ",
                                    //       style: TextStyle(
                                    //           color: Colors.grey,
                                    //           fontSize: 12,
                                    //           fontWeight: FontWeight.bold),
                                    //     ),
                                    //   ],
                                    // ),
                                    // Container(
                                    //   width: MediaQuery.sizeOf(context).width * 0.8,
                                    //   height: 25,
                                    //   child: ListView.builder(
                                    //     shrinkWrap: true,
                                    //     scrollDirection: Axis.horizontal,
                                    //     physics: NeverScrollableScrollPhysics(),
                                    //     itemCount: item['expert_languages']
                                    //         .replaceAll('[', '')
                                    //         .replaceAll(']', '')
                                    //         .split(',')
                                    //         .length,
                                    //     itemBuilder: (context, i) {
                                    //       return Container(
                                    //         decoration: BoxDecoration(
                                    //             color: Colors.grey.shade300,
                                    //             borderRadius: BorderRadius.circular(4)),
                                    //         alignment: Alignment.center,
                                    //         padding: EdgeInsets.symmetric(
                                    //             horizontal: 6, vertical: 1),
                                    //         margin: EdgeInsets.only(right: 8),
                                    //         child: Text(
                                    //           style: TextStyle(fontSize: 12),
                                    //           "${item['expert_languages'].replaceAll('[', '').replaceAll(']', '').split(',')[i].replaceAll('"', '')}",
                                    //         ),
                                    //       );
                                    //     },
                                    //   ),
                                    // ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       "${item['expert_languages']}",
                                    //       style: TextStyle(fontSize: 10),
                                    //     ),
                                    //     Text(
                                    //       "${item['expert_languages'][1]} ",
                                    //       style: TextStyle(fontSize: 10),
                                    //     ),
                                    //     Text(
                                    //       "${item['expert_languages'][2]} ",
                                    //       style: TextStyle(fontSize: 10),
                                    //     ),
                                    //   ],
                                    // ),

                                    // if (item['expert_languages'] !=
                                    //         null &&
                                    //     item['expert_languages']
                                    //         .isNotEmpty) ...[
                                    //   Text("| "),

                                    // ],
                                    Text(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      "${item['expert_long_description'] ?? "${item['sponsor_profile_description'] ?? "${item['sponsor_topic_description']}"}"}",
                                      style: TextStyle(
                                          color: Blackcolor, fontSize: 12),
                                    ),
                                    SizedBox(height: 2),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : (showLoader == false)
                          ? Column(
                          
                              children: [
                                Image.asset(
                                  'assets/gifnoresults.gif',
                                 color: Blackcolor,
                                  width: 200,
                                  height: 300,
                                ),
                                Text("Try entering a different keyword", style: TextStyle(color:Colors.grey, fontSize: 18),)
                              ],
                            )
                          : SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
