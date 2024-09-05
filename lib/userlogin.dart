import 'dart:io';

import 'package:Anyquire/HomeController.dart';
import 'package:Anyquire/api.dart';
import 'package:Anyquire/main.dart';
import 'package:Anyquire/otpvalidate.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:page_transition/page_transition.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  RegExp phoneNumberRegex = RegExp(r'^\d{10}$');
  bool checknum = false;
  bool showLoader = false;
  String phoneCheck = "";
  final _formKey = GlobalKey<FormState>();

  String phoneno = "";

  bool checkEmptyno = false;
  FocusNode myFocusNode = new FocusNode();
  //bool otpLoader = false;
  String countrycode = "+91";

  TextEditingController phnnocontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future signInCustomFlow(String username) async {
    print(' Phone is:  $countrycode${phnnocontroller.text}');
    await Amplify.Auth.signOut();
    final num = "$countrycode" "${phnnocontroller.text}";
    try {
      final result = await Amplify.Auth.signIn(username: num.trim());
      print(result);
      return 'success';
    } on AuthException catch (e) {
      if (e.message.contains('NOT_AUTHORIZED')) {
        String Source = "";
        if (Platform.isAndroid) {
          Source = "Android";
        } else {
          Source = "Ios";
        }
        await Api().user_signup(phoneno, Source);

        signInCustomFlow(username);
      }

      return e.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        onHorizontalDragDown: ((_) {
          FocusScope.of(context).unfocus();
        }),
        child: Container(
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: Container(
              height: MediaQuery.sizeOf(context).height * 0.95,
              // alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),
                    // SizedBox(
                    //   height: 80,
                    // ),
                    Center(
                      child: Image.asset(
                        'assets/mailbox.png',
                        height: MediaQuery.sizeOf(context).height * 0.3,
                        //width: 200,
                      ),
                    ),

                    Text(
                      'Mobile Registration',
                      style: TextStyle(
                          color: Blackcolor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                    //Spacer(),
                    SizedBox(
                      height: 10,
                    ),
                    //Spacer(),
                    Text(
                      'We will send you One Time Password on\nthis mobile number',
                      style:
                          TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    ),
                    SizedBox(height: 20),
                    // Spacer(),
                    SizedBox(
                      // height: 90,
                      child: IntlPhoneField(
                        flagsButtonPadding: EdgeInsets.all(5),
                        // dropdownTextStyle: TextStyle(color: Blackcolor),
                        showDropdownIcon: true,
                        style: TextStyle(color: Blackcolor),
                        decoration: InputDecoration(
                          prefixIconColor:
                              myFocusNode.hasFocus ? Blackcolor : Textcolor,
                          labelText: 'Mobile Number',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: myFocusNode.hasFocus
                                  ? Blackcolor
                                  : Textcolor),
                          contentPadding: EdgeInsets.all(8),

                          // // border: InputBorder.none,
                          errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(color: Blackcolor)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(color: Blackcolor)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(color: Blackcolor)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(color: Blackcolor)),
                          enabledBorder: (checkEmptyno == true &&
                                  phnnocontroller.text.isEmpty)
                              ? OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                          255, 160, 43, 34)))
                              : OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(color: Blackcolor)),
                        ),

                        cursorColor: Blackcolor,
                        controller: phnnocontroller,
                        onChanged: (value) {
                          countrycode = value.countryCode;
                          phoneno = value.completeNumber;
                          phoneCheck = value.number;
                          print(value.completeNumber);
                          if (phoneCheck.length == 10) {
                            FocusManager.instance.primaryFocus!.unfocus();
                          }
                          if (phoneNumberRegex.hasMatch(value.number)) {
                            FocusManager.instance.primaryFocus!.unfocus();
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             OtpValidate(phnnocontroller.text)));
                            print('$countrycode${phnnocontroller.text}');
                            setState(() {
                              checknum = true;
                            });
                          } else {
                            setState(() {
                              checknum = false;
                            });
                          }
                        },
                        initialCountryCode: "IN",
                        //   decoration: InputDecoration(
                        //   labelText: 'Phone Number',
                        // labelStyle: TextStyle(color: Colors.white),
                        // )
                      ),
                    ),
                    if (checkEmptyno == true)
                      if (phnnocontroller.text.isEmpty)
                        Row(
                          children: [
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              'Enter Phone Number',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 160, 43, 34)),
                            ),
                            Spacer()
                          ],
                        ),
                    //SizedBox(height: 10),
                    //    Spacer(),
                    SizedBox(
                      height: 45,
                      width: 700,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(
                                5,
                              ))),
                              backgroundColor: Buttoncolor,
                              foregroundColor: Colwhite),
                          // disabledForegroundColor: Bluecolor,
                          // disabledBackgroundColor: Bluecolor),
                          onPressed: () async {
                            setState(() {
                              checkEmptyno = true;
                            });
                            if ((_formKey.currentState!.validate()) &&
                                (phoneCheck.length == 10)) {
                              setState(() {
                                showLoader = true;
                              });

                              print(' you are sending this : $phoneno');
                          //    var euu = await signInCustomFlow(phoneno);
                            //  print("EEEEEEEEEEEEEE: $euu");

                              setState(() {
                                showLoader = false;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      //HomeController()
                                          OtpValidate(phnnocontroller.text)
                                          
                                          ));

                              // Navigator.push(
                              //     context,
                              //     PageTransition(
                              //         type: PageTransitionType.bottomToTop,
                              //         child: OtpValidate(
                              //           phnnocontroller.text,
                              //         )));
                            }
                          },
                          child: Text('Get OTP',
                              style: TextStyle(fontSize: 18, color: Colwhite))),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    SizedBox(height: 10),
                    (showLoader == true)
                        ? SpinKitFadingCircle(
                          size: 35,
                            color: Textcolor,
                          )
                        : SizedBox(),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
