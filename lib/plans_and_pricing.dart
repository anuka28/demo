import 'dart:convert';

import 'package:Anyquire/api.dart';
import 'package:Anyquire/main.dart';
import 'package:Anyquire/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlansAndPricing extends StatefulWidget {
  const PlansAndPricing({super.key});

  @override
  State<PlansAndPricing> createState() => _PlansAndPricingState();
}

class _PlansAndPricingState extends State<PlansAndPricing> {
  String? ConsumerNumber = ""; //ConsumerCredit
  bool loader = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callapi();
  }

  callapi() async {
    await Api().getUserDetails();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    ConsumerNumber = sharedPreferences.getString("Phonenumber") ?? "";

    print("ConsumerNumber$ConsumerNumber");
  }

  List amountList = [
    50,
    0100,
    200,
    500,
    1000,
    2000,
    3000,
    4000,
    8000,
    15000,
    20000
  ];
  int SelectedIndex = 4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: BackButton(color: Textcolor,),
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Plans and Pricing',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      // appBar: PreferredSize(
      //     preferredSize:
      //         Size.fromHeight(MediaQuery.of(context).size.height * 0.15),
      //     child: Container(

      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           const Spacer(),
      //           Row(
      //             children: [
      //               // Padding(
      //               //   padding: const EdgeInsets.all(10.0),
      //               //   child: GestureDetector(
      //               //     onTap: () {
      //               //       Navigator.pop(context);
      //               //     },
      //               //     child: Icon(
      //               //       Icons.arrow_back_ios,
      //               //       size: 20,
      //               //       color: Colors.white,
      //               //     ),
      //               //   ),
      //               // ),
      //               // const Spacer(),
      //               const Text(
      //                 'Plans and Pricing',
      //                 style: TextStyle(
      //                   fontSize: 26.0,
      //                   fontWeight: FontWeight.bold,
      //                   color: Colors.black,
      //                 ),
      //               ),
      //             ],
      //           ),
      //           SizedBox(
      //             height: MediaQuery.of(context).size.height * 0.03,
      //           )
      //         ],
      //       ),
      //     )),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(15),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recommended",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 121, 121, 121)),
                    ),
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
                    InkWell(
                      onTap: () {
                        setState(() {
                          SelectedIndex = 4;
                          print("selected :4");
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: (SelectedIndex != 4)
                                    ? Colors.grey
                                    : Textcolor),
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "1000 CREDITS",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromARGB(
                                          255, 111, 111, 111)),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "\u{20B9} 1180",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 21),
                                    ),
                                    Text(" | \u{20B9} 1000 + GST"),
                                  ],
                                )
                              ],
                            ),
                            Spacer(),
                            Icon(Icons.circle,
                                color: (SelectedIndex != 4)
                                    ? Colors.grey
                                    : Textcolor),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
                    Text(
                      "More Consumer Transaction",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 121, 121, 121)),
                    ),
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
                    Container(
                      //height: MediaQuery.sizeOf(context).height * 0.54,
                      child: ListView.builder(
                        itemCount: amountList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                SelectedIndex = index;
                                print("selected :$index");
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: (SelectedIndex == index)
                                          ? Textcolor
                                          : Colors.grey),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${amountList[index]} CREDITS",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromARGB(
                                                255, 111, 111, 111)),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "\u{20B9} ${(double.parse(amountList[index].toString()) * 1.18).toStringAsFixed(0)}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 21),
                                          ),
                                          Text(
                                              " | \u{20B9} ${amountList[index]} + GST"),
                                        ],
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  Icon(Icons.circle,
                                      color: (SelectedIndex == index)
                                          ? Textcolor
                                          : Colors.grey),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              //Spacer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(10),
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height * 0.068
        ,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Textcolor,
                foregroundColor: Colors.white),
            onPressed: () async {
              setState(() {
                loader = true;
              });

              var billing_amount = amountList[SelectedIndex] * 1.18;
              var order_id = await create_order(billing_amount);
              print("order ID: $order_id");
              setState(() {
                loader = false;
              });
              if (order_id != "Fail") {
                await Razorpay_Options(billing_amount, order_id);

                //await Api().getUserDetails();
              }
            },
            child: (loader == true)
                ? Center(
                    child: SpinKitFadingCircle(
                      size: 35,
                    color: Colors.white,
                  ))
                : Text(
                    "Proceed to Pay",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
      ),
    );
  }

  Razorpay_Options(amount, orderID) {
    Razorpay razorpay = Razorpay();
    var options = {
      //fill options here

      // 'key': 'rzp_live_E4Wv12VZpnQzUa',
      'key': 'rzp_test_fn7n6bC23PIxXQ',
      'amount': 100 * amount,
      'name': 'Anyquire Credits',
      'description': 'Credits',

      'order_id': orderID,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '${User.userPhonenumber}'},
      'theme': {'color': '#8354E2'},
      // 'image': 'assets/LaunchLogo-aq.png'

      // 'external': {
      //   'wallets': ['paytm']
      //             }
    };
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    razorpay.open(options);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    String message = "";
    if (response.code == 0) {
      message =
          "There was a network error, for example loss of internet connectivity";
    } else if (response.code == (1)) {
      message = "	An unknown error occurred.";
      print("Error description: ${response.message}");
    } else if (response.code == 2) {
      message = "	User cancelled the payment";
      print("Error description: ${response.message}");
    } else if (response.code == (3)) {
      message = "	An unknown error occurred.";
      print("Error description: ${response.message}");
    } else if (response.code == (4)) {
      message = "	An unknown error occurred.";
      print("Error description: ${response.message}");
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Text("Payment Failed  "),
                Icon(Icons.thumb_down, color: Colors.red, size: 15)
              ],
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Text("${message}"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Proceed"),
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
              )
            ],
          );
        });
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Api().getUserDetails();
    print(
        "order iD: ${response.orderId} transaction ID: ${response.paymentId}");

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Text(
                  "Amount recharged successfully ",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.thumb_up,
                  color: Colors.green,
                  size: 15,
                )
              ],
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image.asset('assets/tip.png',height: 150,width: 150,),
                Text("Payment ID: ${response.paymentId}"),
                Text("Thank you for using anyquire!"),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("Continue"),
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
              )
            ],
          );
        });
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("External Wallet Selected"),
            content: Text("\nPayment ID: ${response.walletName}"),
          );
        });
  }

  create_order(amount) async {
    print("amount$amount");
    print("ConsumerNumber${User.userPhonenumber}");

    try {
      var url = Uri.parse(
          "https://6buq4qbi46.execute-api.ap-south-1.amazonaws.com/Any/createOrder");
      var response = await http.post(
        url,
        body: jsonEncode({
          "command": "createOrder",
          "amount": "$amount",
          "currency": "INR",
          "consumer_phone_number": "${User.userPhonenumber}",
        }),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': 'IjTmpS9QCM8QcrIZZ2pHy64TS6oPdw6A7In2K1M7',
        },
      );
      var body = jsonDecode(response.body);

      print("orderr: $body");
      if (body['status'] == "created") {
        print("Order ID Generated!!");
        return body['id'];
      } else {
        print("Rrrrrrrrrr: $body");
        return "Fail";
      }
    } catch (e) {
      print("error: $e");
      return "Fail";
    }
  }
}
