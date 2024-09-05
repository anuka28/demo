import 'package:Anyquire/api.dart';
import 'package:Anyquire/expertdetails.dart';
import 'package:Anyquire/main.dart';
import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class CallLogsPage extends StatefulWidget {
  const CallLogsPage({super.key});

  @override
  State<CallLogsPage> createState() => _CallLogsPageState();
}

class _CallLogsPageState extends State<CallLogsPage> {
  List callHIstory = [];
  bool showLoader = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callApi();
  }

  callApi() async {
    final abc = await Api().listUserCallHistory();
    if (abc != "ERROR") {
      setState(() {
        callHIstory = abc;
      });
      print("callHIstory${callHIstory}");
    }
    setState(() {
      showLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: PreferredSize(
        //   preferredSize:
        //       Size.fromHeight(MediaQuery.of(context).size.height * 0.15),
        //   child: CustomAppBar(),
        // ),
        body: callHIstory.isEmpty
            ? showLoader == true
                ? SpinKitFadingCircle(
                  size: 35,
                    color: Textcolor,
                  )
                : Container(
                    alignment: Alignment.center,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
                        Image.asset(
                          'assets/NocallHistory.png',
                          width: 200,
                          height: 200,
                        ),
                        Text(
                          "No Calls made",
                          style: TextStyle(
                            color: Colors.grey,
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )
            :
            //Column(
            // children: [
            //   Container(
            //     margin: const EdgeInsets.all(16.0),
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(20.0),
            //       color: Colors.grey[200],
            //     ),
            //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //     child: const TextField(
            //       decoration: InputDecoration(
            //         hintText: 'Search',
            //         border: InputBorder.none,
            //         prefixIcon: Icon(Icons.search),
            //       ),
            //     ),
            //   ),

            SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    // Container(
                    //   margin: EdgeInsets.symmetric(horizontal: 25),
                    //   child: Text(
                    //     'Call Logs',
                    //     style: TextStyle(
                    //       fontSize: 24.0,
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.black,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: callHIstory.length,
                      itemBuilder: (context, index) {
                        var currentindex = callHIstory[index];
                        print("currentindex$currentindex");
                        return InkWell(
                          onTap: () {
                            String expert_display_id =
                                currentindex["other_details"]["expert_name"]
                                    .toString()
                                    .replaceAll(" ", "")
                                    .toLowerCase();
                            print("namee: $expert_display_id");
                            
                        

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AbtConslt(expert_display_id)));
                          },
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16.0),
                                leading: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(color: Colors.transparent),
                                  ),
                                  child: currentindex['other_details']
                                              ['expert_profile_pic_url'] !=
                                          null
                                      ? FutureBuilder(
                                          future: getPresignedUrlForPic(
                                              currentindex['other_details']
                                                  ['expert_profile_pic_url']),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  "${snapshot.data}",
                                                ),
                                              );
                                            } else if (snapshot.hasError) {
                                              return Icon(
                                                Icons.error_outline,
                                                color: Colors.red,
                                                size: 60,
                                              );
                                            } else {
                                              return ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  screenSize.width * 0.2,
                                                ),
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Colors
                                                                .blueGrey)),
                                                    width:
                                                        screenSize.width * 0.4,
                                                    height:
                                                        screenSize.width * 0.4,
                                                    alignment: Alignment.center,
                                                    child: Image.asset(
                                                        "assets/LaunchLogo-aq.png")),
                                              );
                                            }
                                          },
                                        )
                                      : CircleAvatar(
                                          backgroundImage: AssetImage(
                                              "assets/LaunchLogo-aq.png"),
                                        ),
                                ),
                                // CircleAvatar(
                                //   backgroundImage:
                                //       NetworkImage('https://via.placeholder.com/150'),
                                // ),

                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '${currentindex["other_details"]["expert_name"]}\n',
                                                  // overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                WidgetSpan(
                                                  child: SizedBox(height: 20),
                                                ),
                                                TextSpan(
                                                    text:
                                                        '${DateFormat('hh:mm a, dd MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(currentindex["other_details"]['call_start_time']).toUtc())}',
                                                    style: TextStyle(
                                                        color: Colors.grey)),
                                                          WidgetSpan(
                                                  child: SizedBox(width: MediaQuery.sizeOf(context).width *0.18),
                                                ),
                                                        WidgetSpan(child: Icon(Icons.info_outlined, size: 20,color: Textcolor,))
                                                    
                                                //   TextSpan(
                                                //       text: currentindex[
                                                //                       "other_details"]
                                                //                   [
                                                //                   "call_duration"] <
                                                //               60
                                                //           ? ' \n${currentindex["other_details"]["call_duration"]} Sec'
                                                //           : ' \n${(double.parse(currentindex["other_details"]["call_duration"].toString()) / 60).toStringAsFixed(1)} Min',
                                                //       style: TextStyle(
                                                //           color: Colors.grey)),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.access_time_rounded,
                                                size: 15,
                                              ),
                                              Text(
                                                  currentindex["other_details"][
                                                              "call_duration"] <
                                                          60
                                                      ? ' ${currentindex["other_details"]["call_duration"]} Sec'
                                                      : ' ${(double.parse(currentindex["other_details"]["call_duration"].toString()) / 60).toStringAsFixed(1)} Min',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 15))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Divider(
                                  thickness: 0.3,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  getPresignedUrlForPic(key) async {
    var tempUrl = await Api().getPresigneds3url(key);
    return tempUrl;
  }
}

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(5.0),
          bottomRight: Radius.circular(5.0),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //   const Spacer(),
            // const Text(
            //   'Call Logs',
            //   style: TextStyle(
            //     fontSize: 26.0,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.black,
            //   ),
            // ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.03,
            // )
          ],
        ),
      ),
    );
  }
}
