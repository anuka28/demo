import 'package:Anyquire/api.dart';
import 'package:Anyquire/main.dart';
import 'package:Anyquire/plans_and_pricing.dart';
import 'package:Anyquire/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsumerTranaction extends StatefulWidget {
  const ConsumerTranaction({super.key});

  @override
  State<ConsumerTranaction> createState() => _ConsumerTranactionState();
}

class _ConsumerTranactionState extends State<ConsumerTranaction> {
  List TransactionHistory = [];
  //String? ConsumerCredit = "";
  bool showLoader = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callapi();
  }

  callapi() async {
    await Api().getUserDetails();
    var abc = await Api().getUserTransactionHistory();

    print("transactions: $abc");

    // await Api().getUserDetails();
    //SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (abc != "ERROR") {
      setState(() {
        TransactionHistory = abc;
      });
      print("TransactionHisddddtory${TransactionHistory}");
    }
    setState(() {
      // print("checkingggg");
      //ConsumerCredit = sharedPreferences.getString("ConsumerCredit") ?? "";
      showLoader = false;
    });

    print("ConsumerNumber${User.userCredits}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: MediaQuery.sizeOf(context).width,
                padding:
                    EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Column(
                  children: [
                    //   SizedBox(height: MediaQuery.sizeOf(context).height * 0.025),
                    // Row(
                    //   children: [
                    //     Text(
                    //       "Transactions",
                    //       style: TextStyle(
                    //           color: Colors.black,
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 24),
                    //     ),
                    //   ],
                    // ),
                    //   SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 70, 70, 70),
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "\u20B9 ${User.userCredits}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: User.userCredits == 0
                                            ? Colors.white
                                            : Colors.white),
                                  ),
                                  if (User.userCredits == 0)
                                    Text(
                                      "Low balance can't initiate call",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.red),
                                    ),
                                ],
                              ),
                              Container(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.042,
                                // width: MediaQuery.sizeOf(context).width * 0.24,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  PlansAndPricing()))
                                          .then((value) => callapi());
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          size: 16,
                                        ),
                                        Text(
                                          "ADD",
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ),
                        leading: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: Icon(Icons.wallet_rounded)),
                      ),
                    ),
                  ],
                )),
            // Container(
            //   height: MediaQuery.of(context).size.height * 0.06,
            //   margin: const EdgeInsets.only(top: 10.0, right: 10, left: 10),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(20.0),
            //     color: Colors.grey[200],
            //   ),
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: const TextField(
            //     decoration: InputDecoration(
            //       hintText: 'Search',
            //       border: InputBorder.none,
            //       prefixIcon: Icon(Icons.search),
            //     ),
            //   ),
            // ),
            TransactionHistory.isEmpty
                ? showLoader == true
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Center(
                          child: SpinKitFadingCircle(
                            size: 35,
                            color: Textcolor,
                          ),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(top: 30),
                        //  alignment: Alignment.center,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.09),
                            Image.asset(
                              'assets/nomoney.png',
                              width: 180,
                              height: 200,
                            ),
                            Text(
                              "No transactions made",
                              style: TextStyle(color: Colors.grey,
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: TransactionHistory.length,
                    itemBuilder: (context, index) {
                      var currentindex = TransactionHistory[index];
                      print("currentindex$currentindex");
                      return Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.stars_rounded, color: Color.fromARGB(255, 253, 203, 56),),
                            // CircleAvatar(
                            //   backgroundImage:
                            //       NetworkImage('https://via.placeholder.com/150'),
                            // ),
                            subtitle: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentindex["audit_log_sub_module"] ==
                                              "USER_RECHARGED"
                                          ? "Credit Recharge"
                                          : "Call Debit",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${DateFormat('hh:mm a, dd MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(currentindex['audit_log_created_on_time_stamp']))}',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${currentindex["audit_log_sub_module"] == "USER_RECHARGED" ? "+" : ""}${currentindex["credits_gain_or_loss"] != null ? double.parse(currentindex["credits_gain_or_loss"].toString()).toStringAsFixed(2) : 0.00}\u20B9",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: currentindex[
                                                      "audit_log_sub_module"] ==
                                                  "USER_RECHARGED"
                                              ? Colors.green
                                              : Colors.red),
                                    ),
                                    Text(
                                      "Balance \u20B9${currentindex["consumer_new_credit"] != null ? double.parse(currentindex["consumer_new_credit"].toString()).toStringAsFixed(2) : 0.00}",
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),

                            onTap: () {},
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Divider(
                              thickness: 0.35,
                            ),
                          )
                        ],
                      );
                    },
                  ),

            // Container(
            //   margin: EdgeInsets.all(15),
            //   child: Row(
            //     children: [
            //       Icon(Icons.stars_rounded),
            //       SizedBox(width: MediaQuery.sizeOf(context).width * 0.05),
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             "Recharged Credits",
            //             style: TextStyle(fontWeight: FontWeight.bold),
            //           ),
            //           Text("05:15 pm, 14 April 2024")
            //         ],
            //       ),
            //       Spacer(),
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.end,
            //         children: [
            //           Text(
            //             "+50",
            //             style: TextStyle(
            //                 fontWeight: FontWeight.bold, color: Colors.green),
            //           ),
            //           Text("Balance Rs.75.23")
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
