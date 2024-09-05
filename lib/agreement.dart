import 'package:Anyquire/HomeController.dart';
import 'package:Anyquire/api.dart';
import 'package:Anyquire/homescreen.dart';
import 'package:Anyquire/main.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Agreement extends StatefulWidget {
  const Agreement();

  @override
  State<Agreement> createState() => _AgreementState();
}

class _AgreementState extends State<Agreement> {
  bool accept = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   surfaceTintColor: Colors.transparent,
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Terms and Conditions",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                    "Welcome to Anyquire! By accessing or using Anyquire's services, including but not limited to browsing our website or initiating calls through our platform, you agree to comply with and be bound by the following terms and conditions of use. Please read these terms carefully before using Anyquire's services. Please read these terms carefully before using Anyquire's services."),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "1. Acceptance of Terms",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                    "By using Anyquire's services, you agree to these terms of service and our privacy policy. If you do not agree with any part of these terms, you may not use our services."),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "2. Description of Service",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                    "Anyquire provides a voice-based solution where users can connect with experts/providers for consultations via voice calls. Users pay experts/providers on a per-minute basis for the calls facilitated through the Anyquire platform. Anyquire only acts as a bridge for the calls and does not have access to the contents of the call itself. Anyquire is not privy to the actual conversation that transpires between the user and the provider. Anyquire's responsibility is limited to facilitating the connection between the two parties."),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "3. User Conduct",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                    "Users are solely responsible for their conduct and the content they generate while using Anyquire's services. Users must not engage in any unlawful, offensive, or abusive behavior while using the platform."),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "4. Payment",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                    "Users will be charged per minute as per the pricing set by the expert/provider for the duration of the call. Users are responsible for any charges incurred while using Anyquire's services."),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "5. Privacy and Confidentiality",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                    "Anyquire respects user privacy and confidentiality. Call recordings or transcripts are never stored on the Anyquire platform. Users and providers are responsible for maintaining the confidentiality of their conversations."),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "6. Limitation of Liability",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                    "Anyquire shall not be liable for any direct, indirect, incidental, special, or consequential damages arising out of or in any way connected with the use of our services. Anyquire is not responsible for the advice or service provided during the call."),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "7. Modification of Terms",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                    "Anyquire reserves the right to modify these terms of service at any time without prior notice. Users are responsible for reviewing these terms periodically for changes."),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "8. Governing Law",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                    "These terms of service shall be governed by and construed in accordance with the laws of Bangalore, India, without regard to its conflict of law provisions."),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "9. Contact Information",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                    "If you have any questions or concerns about these terms of service, please contact us at contactus@anyquire.com. By using Anyquire's services, you acknowledge that you have read, understood, and agree to be bound by these terms of service."),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Checkbox(
                      activeColor: Textcolor,
                      value: accept,
                      onChanged: (value) {
                        setState(() {
                          accept = !accept;
                        });
                      }),
                  InkWell(
                      splashColor: Colors.white,
                      highlightColor: Colors.white,
                      onTap: () {
                        setState(() {
                          accept = !accept;
                        });
                      },
                      child: Text(
                        "I Agree to the terms and conditions",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                ],
              ),
              Row(
                children: [
                  SizedBox(width: MediaQuery.sizeOf(context).width * 0.04),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                          backgroundColor:
                              (accept == false) ? Colors.grey : Textcolor,
                          foregroundColor: Colors.white),
                      onPressed: (accept == false)
                          ? null
                          : () async {
                              await Api().editConsumer("", true);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeController()),
                                  (route) => false);
                            },
                      child: Text("Agree and continue")),
                ],
              )
            ],
          )),
    );
  }
}
