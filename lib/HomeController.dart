import 'package:Anyquire/call_logs.dart';
import 'package:Anyquire/terms.dart';
import 'package:Anyquire/user_wallet.dart';

import 'package:Anyquire/main.dart';

import 'package:Anyquire/usersearch.dart';
import 'package:flutter/material.dart';

class HomeController extends StatefulWidget {
  const HomeController({super.key});

  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return DefaultTabController(
      animationDuration: Durations.short2,
      length: 4,
      child: SafeArea(
        bottom: true,
        top: false,
        child: Scaffold(
            body: TabBarView(
              
                physics: NeverScrollableScrollPhysics(),
                children: [
                  UserSearch(),
                  CallLogsPage(),
                  ConsumerTranaction(),
                  ConsumerProfilePage()
                ]),
            bottomNavigationBar: Container(
              
              decoration: BoxDecoration( 
               borderRadius: BorderRadius.circular(10),
          


                   color: Colors.white,border: Border.all(color:Color.fromARGB(255, 206, 204, 204)), 
                   ),
           
              height: MediaQuery.sizeOf(context).height*0.09,
           
              // const Color.fromARGB(255, 206, 204, 204),
              child: TabBar(
                
              
             unselectedLabelColor: Colors.black,
             labelColor: Textcolor,
                      
                        
                indicatorColor: Textcolor,
        //        dividerColor: Blackcolor,
               
                  isScrollable: false,
                  indicatorWeight: 3,
                 labelPadding: EdgeInsets.all(0),
                    
                  labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                      icon: Icon(
                       
                        Icons.search,
                        color: Colors.black,
                      ),
                      text: "Search",
                    ),
                    Tab(
                        icon: Icon(
                          Icons.call,
                          color:  Colors.black,
                        ),
                        text: 'Call Logs', ),
                    Tab(
                      icon: Icon(
                        color: Colors.black,
                        Icons.wallet,
                      ),
                      text: 'Transactions',
                    ),
                    Tab(
                      icon: Icon(
                        color: Colors.black,
                        Icons.privacy_tip_outlined,
                      ),
                      text: 'Terms',
                    )
                  ]),
            )),
      ),
    );
  }
}
