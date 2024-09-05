import 'dart:async';
import 'dart:io';

import 'package:Anyquire/HomeController.dart';
import 'package:Anyquire/agreement.dart';
import 'package:Anyquire/api.dart';
import 'package:Anyquire/homescreen.dart';
import 'package:Anyquire/main.dart';
import 'package:Anyquire/user.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpValidate extends StatefulWidget {
  final phoneNumber;
  const OtpValidate(this.phoneNumber);

  @override
  State<OtpValidate> createState() => _OtpValidateState();
}

class _OtpValidateState extends State<OtpValidate> {
  int seconds = 60;
  Map CurrentUser = {};
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    starttime();
  }

  starttime() {
    const oneSec = const Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (seconds == 0) {
            timer.cancel();
          } else {
            seconds--;
          }
        },
      ),
    );
  }

  getuserdetails() async {
    print("ewsz");
    await Api().getUserDetails();
    // await Api().getCurrentExpertDetails();
    //  await Api().getExpertDetails(User.consumerid);
  }

  @override
  void dispose() {
    // Clean up the timer when the screen is disposed
    timer?.cancel();
    super.dispose();
  }

  String countrycode = "+91";
  bool Loggedin = false;
  //FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController otpcontroller = TextEditingController();
  bool otpLoader = false;

  confirmSignIn(code, context) async {
    try {
      final result = await Amplify.Auth.confirmSignIn(confirmationValue: code);
      print('ressssss ' '${result.isSignedIn}');
      if (result.isSignedIn == false) {
        print('here');
        //showError

        // showDialogError(context, 'Please enter the correct OTP');
      } else {
        print('success');
        return "success";
      }
    } on AuthException catch (e) {
      safePrint('Error signing in: ${e.message}');
    }
  }

  Future signInCustomFlow(String username) async {
    print(' Phone is:  $countrycode${widget.phoneNumber}');
    await Amplify.Auth.signOut();
    final num = "$countrycode" "${widget.phoneNumber}";
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
        await Api().user_signup(widget.phoneNumber, Source);

        signInCustomFlow(username);
      }

      return e.message;
    }
  }

  // CustomInputFormatter() {
  //   TextEditingValue formatEditUpdate(
  //       TextEditingValue oldValue, TextEditingValue newValue) {
  //     String newText = newValue.text;

  //     if (newText.length > 3 && !newText.contains('-')) {
  //       // Insert '-' after the 3rd character
  //       newText = newText.substring(0, 3) + '-' + newText.substring(3);
  //     }

  //     return TextEditingValue(
  //       text: newText,
  //       selection: TextSelection.collapsed(offset: newText.length),
  //     );
  //   }

  Future resendOtp(String phoneNumber) async {
    try {
      final result = await Amplify.Auth.signIn(username: phoneNumber.trim());
      print(result);
      setState(() {
        seconds = 60;
      });
      starttime();
      Fluttertoast.showToast(
        msg: "OTP Resent successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } on AuthException catch (e) {
      if (e.message.contains('NOT_AUTHORIZED')) {
        String Source = "";
        if (Platform.isAndroid) {
          Source = "Android";
        } else {
          Source = "Ios";
        }
        await Api().user_signup(phoneNumber, Source);

        signInCustomFlow(phoneNumber);
      }

      return e.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      onHorizontalDragDown: ((_) {
        FocusScope.of(context).unfocus();
      }),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 20,),
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackButton( color: Textcolor,),
          Container( 
            padding: EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
               children: [ 
                Center(
                child: Image.asset(
                  'assets/mailbox.png',
                  height: MediaQuery.sizeOf(context).height * 0.3,
                  //width: 200,
                ),
              ),
              Text(
                'OTP Verification',
                style: TextStyle(
                    color: Blackcolor,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    'Enter the code we send to ',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  Text(
                    "+91${widget.phoneNumber}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              PinCodeTextField(
                  enablePinAutofill: true,

                  // backgroundColor: Colors.grey[200],
                  controller: otpcontroller,
                  showCursor: true,
                  cursorColor: Textcolor,
                  appContext: context,
                  length: 6,
                  autoFocus: true,
                  autoUnfocus: true,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    activeColor: Buttoncolor,
                    selectedColor: Colors.grey,
                    selectedFillColor: Buttoncolor,
                    activeFillColor: Bluecolor,
                    inactiveColor: Colors.grey,
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 42,
                    borderWidth: 1,
                  ),
                  //  inputFormatters: [CustomInputFormatter()],
                  onCompleted: (value) async {
                    // setState(() {
                    //   otpLoader = true;
                    // });
                    // var res = await confirmSignIn(otpcontroller.text, context);
                    // if (res == 'success') {
                    //   SharedPreferences pref =
                    //       await SharedPreferences.getInstance();
                    //   await pref.setString('pno', widget.phoneNumber);
                    //   pref.setBool("loggedin", true);
                    //   Fluttertoast.showToast(
                    //       msg: "Logged in successfully",
                    //       toastLength: Toast.LENGTH_LONG,
                    //       gravity: ToastGravity.TOP_LEFT,
                    //       timeInSecForIosWeb: 1,
                    //       backgroundColor: Bluecolor,
                    //       textColor: Colwhite,
                    //       fontSize: 16.0);

                    //   Navigator.pushAndRemoveUntil(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => HomeController()),
                    //       (route) => false);
                    // } else {
                    //   setState(() {
                    //     otpLoader = false;
                    //   });
                    //   Fluttertoast.showToast(
                    //       msg: "Invalid OTP",
                    //       toastLength: Toast.LENGTH_SHORT,
                    //       gravity: ToastGravity.CENTER,
                    //       timeInSecForIosWeb: 1,
                    //       backgroundColor: Colors.red,
                    //       textColor: Colors.white,
                    //       fontSize: 16.0);
                    //   setState(() {
                    //     otpLoader = false;
                    //   });
                    // }
                  }),
              SizedBox(height: 10),
              Container(
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(
                          5,
                        ))),
                        backgroundColor: Buttoncolor,
                        foregroundColor: Colors.white),
                    onPressed: () async {
                      setState(() {
                        otpLoader = true;
                      });
                      // var res =
                      //     await confirmSignIn(otpcontroller.text, context);
                      // if (res == 'success') 
                      {
                        await getuserdetails();
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        await pref.setString('pno', widget.phoneNumber);
                        pref.setBool("loggedin", true);
                        Fluttertoast.showToast(
                            msg: "Logged in successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP_LEFT,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Textcolor,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        if (User.accept_terms == false) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Agreement()),
                              (route) => false);
                        } else {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeController()),
                              (route) => false);
                        }
                      
                
                        setState(() {
                          otpLoader = false;
                        });
                        Fluttertoast.showToast(
                            msg: "Invalid OTP",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        setState(() {
                          otpLoader = false;
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Submit',
                            style: TextStyle(fontSize: 18, color: Colwhite,)),
                      ],
                    )),
              ),
            ],),
          ),


            
              Spacer(
                flex: 2,
              ),
              // SizedBox(
              //   height: 25,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn\'t recieve the OTP?  ',
                    style: TextStyle(color: Textcolor),
                  ),
                  seconds != 0
                      ? Text(
                          'Resend OTP in $seconds Sec',
                          style: TextStyle(color: Textcolor),
                        )
                      : TextButton(
                          onPressed: () async {
                            // await signInCustomFlow(widget.phoneNumber);
                            //    Authservice().confirmSignUpPhoneVerification(
                            //    '${widget.countrycode}${widget.phoneNumber}',
                            // "123456");
                            await resendOtp("+91${widget.phoneNumber}");
                          },
                          child: Text(
                            'Resend',
                            style: TextStyle(color: Textcolor, fontWeight: FontWeight.bold),
                          ))
                ],
              ),
          //    SizedBox(height: 20,),

              // InkWell(
              //   onTap: () async {
              //     await signInCustomFlow(widget.phoneNumber);
              //     //   Authservice().confirmSignUpPhoneVerification(
              //     //     '${widget.countrycode}${widget.phoneNumber}',
              //     //   "123456");
              //   },

              //  ),

              (otpLoader == true)
                  ? SpinKitFadingCircle(
                    size: 35,
                      color: Textcolor,
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
