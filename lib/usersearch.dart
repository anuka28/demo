import 'package:Anyquire/api.dart';
import 'package:Anyquire/main.dart';
import 'package:Anyquire/searchresult.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

RxList keywordsList = [].obs;

class UserSearch extends StatefulWidget {
  const UserSearch({super.key});

  @override
  State<UserSearch> createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  bool showLoader = false;
  TextEditingController searchController = TextEditingController();
  String searchkey = "Search";

  @override
  void initState() {
    keywords();
    // TODO: implement initState
    super.initState();
  }

  keywords() async {
    var res = await Api().searchkeywords();
    print("ress: $res");
    if (res != "Error") {
      keywordsList.value = res;
    }

    print("listttt: $keywordsList");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
   
          backgroundColor: Colors.white,
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: Column(children: [
              Spacer(),
              Image.asset(
                'assets/anyquire-logoo.png',
                width: MediaQuery.sizeOf(context).width*0.7,
                height: MediaQuery.sizeOf(context).height*0.1,
              ),
              Hero(
                tag: searchkey,
                child: Material(
                  color: Colors.transparent,
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: searchController,
                    style: TextStyle(color: Blackcolor, fontSize: 14),
                    cursorColor: Textcolor,
                    onChanged: (value) {
                      setState(() {
                        searchkey = value;
                        searchController.text = value;
                      });
                    },
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus!.unfocus(),
                    onFieldSubmitted: (value) async {
                      setState(() {
                        showLoader = true;
                      });
                      FocusManager.instance.primaryFocus!.unfocus();
                      await Api().openSearchForConsultant(searchkey);

                      setState(() {
                        showLoader = false;
                      });
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SearchResult(searchController.text)))
                          .then((value) => searchController.clear());
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        // constraints: BoxConstraints.loose(Size(
                        //     MediaQuery.of(context).size.width * 0.9,
                        //     MediaQuery.of(context).size.height * 0.07)),

                        labelStyle: TextStyle(color: Blackcolor),
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
                                //  IconButton(
                                //     onPressed: () {
                                //       setState(() {
                                //         searchController.text = "";
                                //       });

                                //       searchController.clear();
                                //     },
                                //     icon: Icon(Icons.cancel)),
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
                        hintText: "Search by keywords",
                     //   hintText: "Search for a Provider by keyword",
                        hintStyle: TextStyle(color: Colors.black45)),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 10,
              // ),
              // SizedBox(
              //   height: MediaQuery.sizeOf(context).height * 0.05,
              // ),
              (showLoader == true)
                  ? Center(
                    child: SpinKitFadingCircle(
                      size: 35,
                        color: Textcolor,
                      ),
                  )
                  : SizedBox.shrink(),
              SizedBox(
                
                height: (keywordsList.length ==0)?
                   MediaQuery.sizeOf(context).height * 0.15:
                
                
                 MediaQuery.sizeOf(context).height * 0.05,
              ),
              Obx(
                () => Wrap(
                  children: [
                    for (int i = 0;
                        (keywordsList.length > 10)
                            ? i < 10
                            : i < keywordsList.length;
                        i++)
                      InkWell(
                        onTap: () async {
                          setState(() {
                            showLoader = true;
                          });
                          FocusManager.instance.primaryFocus!.unfocus();
                          await Api().openSearchForConsultant(keywordsList[i]);

                          setState(() {
                            showLoader = false;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SearchResult(keywordsList[i])));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blueGrey.shade100,
                              borderRadius: BorderRadius.circular(6)),
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.all(5),
                          // height: 25,
                          child: Text(
                            '${keywordsList[i]}',
                            style: TextStyle(
                                fontSize: 10,
                                color: Blackcolor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.2,
              )
            ]),
          )),
    );
  }
}
