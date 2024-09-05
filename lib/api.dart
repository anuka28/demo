import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:Anyquire/user.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
// import 'package:intl_phone_field/phone_number.dart';
//import 'package:language_picker/languages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

RxList callHistory = [].obs;
RxList transHistory = [].obs;

class Api {
  static RxList callhisConsultantDetails = [].obs;
  static RxList professionsList = [].obs;
  static RxList subProfessionsList = [].obs;
  static RxList openSearcResult = [].obs;
  static RxList getCurrentConsumerData = [].obs;
  static List<File> selectedImages = [];
  user_signup(phone_number, source) async {
    print("phone_number: $phone_number");
    //print("country_code: $country_code");
    try {
      var url = Uri.parse(
          "https://6buq4qbi46.execute-api.ap-south-1.amazonaws.com/Any/consumer_signup");
      var response = await http.post(
        url,
        body: jsonEncode({
          "command": "createConsumer",
          'consumer_phone_number': phone_number,
          'consumer_creation_source': source
        }),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': 'IjTmpS9QCM8QcrIZZ2pHy64TS6oPdw6A7In2K1M7',
        },
      );
      var body = jsonDecode(response.body);
      print("UserSignup body here: $body");
      if (body['Status'] == "SUCCESS") {
        print("success");
      } else {
        return "Fail";
      }
    } catch (e) {
      print("error: $e");
    }
  }

  ProviderSignup(
      profile_pic,
      name,
      mobileNumber,
      country,
      state,
      long_desc,
      keyword,
      lang,
      exper_charge,
      expertcharge_type,
      expert_agreed_terms_and_conditions) async {
    print("name :$name");
    print("userPhonenumber : $mobileNumber");
    print("country :$country");
    print("state :$state");
    print("long_desc :$long_desc");
    print("exper_charge :$exper_charge");
    print("profile_pic :$profile_pic");
    print("expertcharge_type :$expertcharge_type");
    print(
        "expert_agreed_terms_and_conditions :$expert_agreed_terms_and_conditions");

    try {
      var url = Uri.parse(
          "https://6buq4qbi46.execute-api.ap-south-1.amazonaws.com/Any/expert_sign_up");
      var response = await http.post(
        url,
        body: jsonEncode({
          "expert_name": "$name",
          "expert_phone_number": "+91${mobileNumber}",
          "expert_country": "$country",
          "expert_state": "$state",
          "expert_languages": lang,
          "expert_long_description": "$long_desc",
          "update_source": "Mobile",
          "action": "UPDATE",
          "command": "createExpert",
          "expert_charge_per_minute": exper_charge,
          "expert_charge_type": expertcharge_type,
          if (profile_pic != "") "expert_profile_pic_url": "$profile_pic",
          "search_keywords": keyword,
          "expert_agreed_terms_and_conditions":
              expert_agreed_terms_and_conditions
        }),
        headers: {
          'x-api-key': 'IjTmpS9QCM8QcrIZZ2pHy64TS6oPdw6A7In2K1M7',
        },
      );
      var body = jsonDecode(response.body);

      print("expert signup  body: $body");

      if (body['status'] == "Success") {
        return "Success";
      } else {
        return "Error";
      }
    } catch (e) {
      print("error: $e");
      return "Error";
    }
  }

  Expertnewsignup(
      name,
      email,
      mobileNumber,
      profession,
      profession_id,
      experience,
      country,
      state,
      lang,
      long_desc,
      command,
      exper_charge,
      subprof,
      subprof_id,
      profile_pic,
      expertcharge_type,
      keyword) async {
    print("name :$name");
    print("userPhonenumber : $mobileNumber");
    print("email :$email");
    print("profession :$profession");
    print("profession_id :$profession_id");
    print("experiencfe :$experience");
    print("country :$country");
    print("state :$state");
    print("long_desc :$long_desc");

    print("command :$command");
    print("exper_charge :$exper_charge");

    print("subprof :$subprof");
    print("subprof_id :$subprof_id");
    print("subprof_id :$subprof_id");
    print("profile_pic :$profile_pic");

    print("expertcharge_type :$expertcharge_type");
    try {
      var url = Uri.parse(
          "https://6buq4qbi46.execute-api.ap-south-1.amazonaws.com/Any/expert_sign_up");
      var response = await http.post(
        url,
        body: jsonEncode({
          "expert_name": "$name",
          "expert_phone_number": "+91${mobileNumber}",
          "expert_email_id": "$email",
          "expert_profession": "$profession",
          "expert_profession_id": "$profession_id",
          "expert_experience": experience,
          "expert_country": "$country",
          "expert_state": "$state",
          "expert_languages": lang,
          "expert_long_description": "$long_desc",
          "update_source": "Mobile",
          "action": "UPDATE",
          "command": "createExpert",
          "expert_charge_per_minute": exper_charge,
          "expert_charge_type": expertcharge_type,
          if (profile_pic != "") "expert_profile_pic_url": "$profile_pic",
          if (subprof != "") "expert_sub_profession": "$subprof",
          if (subprof_id != "") "expert_sub_profession_id": "${subprof_id}",
          "search_keywords": keyword
        }),
        headers: {
          'x-api-key': 'IjTmpS9QCM8QcrIZZ2pHy64TS6oPdw6A7In2K1M7',
        },
      );
      var body = jsonDecode(response.body);

      print("expert signup  body: $body");

      if (body['status'] == "Success") {
        return "Success";
      } else {
        return "Error";
      }
    } catch (e) {
      print("error: $e");
      return "Error";
    }
  }

  createUser(user_name, user_mobile) async {
    print('Name is: ${user_name}');
    print(' PHONENUMBER: ${user_mobile}');
    var result = Amplify.API.query(
        request: GraphQLRequest(
            document: ''' mutation CreateUser(\$input: createUserInput!) {
    createUser(input: \$input)
  }
       ''',
            variables: {
          'input': {
            'user_name': "$user_name",
            'user_mobile_number': "$user_mobile",
          }
        }));
    try {
      var response = await result.response;
      print("error :${response.errors}");
      print("REsult sign in :${response.data}");
      var body1 = jsonDecode(response.data);
      var body2 = body1["SignUp"];
      print("BODY2: $body2 ");
      if (body2['status'] == "Success") {
        return "Success";
      } else {
        return "Fail";
      }
    } catch (e) {
      print("error: $e");
    }
  }

  getUserDetails() async {
    // try {
    var result = Amplify.API.query(
        request: GraphQLRequest(
      document: '''query GetCurrentUserDetails {
  getCurrentUserDetails
}''',
    ));

    // try {
    var response = await result.response;
    print("error :${response.errors}");
    print("RESULT OF get user :${response.data}");
    var body1 = jsonDecode(response.data);
    print("body1 $body1");
    var body2 = jsonDecode(body1["getCurrentUserDetails"]);

    //log("bodyssss 2 $body2");
    print('body2$body2');
    var body3 = body2['data']['items'];
    log('body3b it is$body3');

    print("creditsss: ${body3[0]["consumer_credits"]}");
    User.userCredits = body3[0]["consumer_credits"].toString();
    //  User.is_anyquire_expert = body3[0]["is_anyquire_expert"];
    print("User.is_anyquire_expert ${User.is_anyquire_expert}");
    // log("bodyssss 8882 ${body3[0]["consumer_credits"]}");
    User.userPhonenumber = body3[0]["consumer_phone_number"];
    print('User.userPhonenumber${User.userPhonenumber}');
    //User.name = body3[0]["consumer_name"];
    User.consumerid = body3[0]["consumer_id"];
    User.accept_terms = body3[0]["consumer_agreed_terms_and_conditions"];

    print('User.is_anyquire_expert: ${User.is_anyquire_expert}');
    print(
        "terms: ${User.accept_terms}  type: ${User.accept_terms.runtimeType}");

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        "Phonenumber", body3[0]["consumer_phone_number"]);
    sharedPreferences.setString(
        "ConsumerCredit", body3[0]["consumer_credits"].toString());
    print("Phonenumber${sharedPreferences.getString("Phonenumber")}");
    getCurrentConsumerData.value = body3;
    // log("body 3 GssssET USER $body3");
    //
    if (body2['status'] == "Success") {
      return "Success";
    } else {
      return "Fail";
    }
    // } catch (e) {
    //   print("error: $e");

    //   // User.name = body3['consumer_name'] ?? "";
    //   // User.userPhonenumber = body3['consumer_phone_number'];
    //   // User.userCredits = body3['consumer_credits'].toString();
    //   // User.is_anyquire_expert = body3['is_anyquire_expert'] ?? false;
    //   // print("is_anyquire_expert :${User.is_anyquire_expert}");
    //   // Balance.value = body3['consumer_credits'].toString();
    //   // print("USER CREDITS ${User.userCredits}");
    // } catch (e) {}

    // sharedPreferences.setString("userid", userid);
    // var getuserid = sharedPreferences.getString("userid") ?? "";
    // print("USERID it is: $getuserid ");
    //   if (body2['status'] == "Success") {
    //     return "Success";
    //   } else {
    //     return "Fail";
    //   }
    // } catch (e) {
    //   print("error: $e");
    // }
  }

  updateUser(consumer_name, action) async {
    // var fcmToken = (await FirebaseMessaging.instance.getToken())!;
    print('tokenn  $consumer_name');
    // String deviceinfo = await getDeviceInfo();
    var result = Amplify.API.query(
        request: GraphQLRequest(
            document: '''  mutation EditConsumer(\$input: editConsumerInput) {
  editConsumer(input: \$input)
}   ''',
            variables: {
          'input': {
            if (consumer_name != "") 'consumer_name': consumer_name,
            'action': action
          }
        }));
    try {
      var response = await result.response;
      print("error :${response.errors}");
      print("Update user API response :${response.data}");
      //   var body1 = jsonDecode(response.data);
      //   var body2 = body1["SignUp"];
      //   print("BODY2: $body2 ");
      //   if (body2['status'] == "Success") {
      //     return "Success";
      //   } else {
      //     return "Fail";
      //   }
    } catch (e) {
      print("error: $e");
    }
  }

  openSearchForConsultant(searchKey) async {
    print("You are searching for: ${searchKey}");
    try {
      var url = Uri.parse(
          "https://6buq4qbi46.execute-api.ap-south-1.amazonaws.com/Any/search_data");
      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'x-api-key': 'IjTmpS9QCM8QcrIZZ2pHy64TS6oPdw6A7In2K1M7',
          },
          body: jsonEncode({
            "command": "searchData",
            "index_name": "experts",
            "search_input": "${searchKey.trim()}"
          }));

      log("response open search: ${response.body}");
      var body = jsonDecode(response.body);

      if (body['status'] == "SUCCESS") {
        log("cons ${body.runtimeType}");
        log("cons ${body['data']}");
        openSearcResult.value = [];
        openSearcResult.value = body['data'];
        print("Searched Value: ${openSearcResult.value}");
      } else {
        var body = jsonDecode(response.body);
        print('${body}');
        openSearcResult.value = [];
        print('error response: $body');
        var body1 = body[1];
        var a = body[' errorMessage'];
        print('$a');
      }
    } catch (e) {
      print(e);
    }
  }

  checkSignin(phonenumbercheck) async {
    print("phonenumbercheck ${phonenumbercheck}");
    try {
      var url = Uri.parse(
          "https://6buq4qbi46.execute-api.ap-south-1.amazonaws.com/Any/user_signup_check");
      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'x-api-key': 'IjTmpS9QCM8QcrIZZ2pHy64TS6oPdw6A7In2K1M7',
          },
          body: jsonEncode({
            "user_phone_number": phonenumbercheck,
          }));

      log("rcheck sign: ${response.body}");
      var body = jsonDecode(response.body);

      // if (body['status'] == "SUCCESS") {
      log("cons ${body.runtimeType}");
      log("cons ${body['body']['hits']['hits']}");
      openSearcResult.value = body['body']['hits']['hits'];
      print("open: ${openSearcResult.value}");
      // }
    } catch (e) {
      print(e);
    }
  }

  getPresigneds3url(key) async {
    try {
      var url = Uri.parse(
          "https://6buq4qbi46.execute-api.ap-south-1.amazonaws.com/Any/get_presigned_url");
      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'x-api-key': 'IjTmpS9QCM8QcrIZZ2pHy64TS6oPdw6A7In2K1M7',
          },
          body:
              jsonEncode({"command": "generatingS3UploadUrl", "key": "$key"}));

      // log("response presigned : ${response.body}");
      var body = jsonDecode(response.body);

      if (body['status'] == "Success") {
        return body['url'];
      }
    } catch (e) {
      print(e);
    }
  }

  initiateCall(expert_display_id) async {
    print("initiateCall phone number :$expert_display_id");
    var result = Amplify.API.query(
        request: GraphQLRequest(
            document: '''mutation InitiateCall(\$input: initateCallInput) {
  initiateCall(input: \$input)
}''',
            variables: {
          'input': {'anyquire_handle_id': "${expert_display_id}"}
        }));
    try {
      var response = await result.response;
      var body = jsonDecode(response.data);
      print('initiateCall body here: $body');
      print("error :${response.errors}");
      if (response.errors.isNotEmpty) {
        return "Error";
      }
      print("call api :${response.data}");
    } catch (e) {
      print("error initiate call: $e");
      return 'Error';
    }
  }

  getUserCallHistory() async {
    var result = await Amplify.API.query(
        request: GraphQLRequest(
      document: '''query ListUserCallHistory {
    listUserCallHistory
  }''',
    ));
    try {
      var response = await result.response;
      if (response.errors.isEmpty) {
        log("Response from getusercall history: $response");
        var body3 = jsonDecode(response.data);
        // print("body 3 here: $body3");
        var data4 = jsonDecode(body3['getUserCallHistory']);
        // print("data4 : $data4");
        var body5 = data4['data'];
        print("body 5: ${body5}");

        // callHistory.value = body6[0];
        print("list here: $body5");
        callHistory.value = body5;
        return body5;
        //   userDetails.= [];
        // userDetails.value = body['data'];
        // print("open: ${openSearcResult.value}"

        //  print("error :${response.errors}");
        // print("call api :${response.data}");
      } else {
        return "ERROR";
      }
    } catch (e) {
      print("error: $e");
      return "ERROR";
    }
  }

  rateConsultantCall(
      consultant_id, call_id, new_rating, rating_comments) async {
    var result = Amplify.API.query(
        request: GraphQLRequest(
            document:
                '''mutation RateConsultantCall(\$input: rateConsultantCallInput) {
  rateConsultantCall(input: \$input)
}''',
            variables: {
          'input': {
            'consultant_id': "",
            'call_id': "",
            'new_rating': "",
            'rating_comments': ""
          }
        }));
    try {
      var response = await result.response;
      print("error :${response.errors}");
      print("rateConsultantCall response :${response.data}");

      //   }
    } catch (e) {
      print("error: $e");
    }
  }

  listTransaction(status) async {
    print('In transaction api $status');

    var result = await Amplify.API.query(
        request: GraphQLRequest(
            document:
                '''query ListTransactions(\$input: listTransactionsInput) {
  listTransactions(input: \$input)
}''',
            variables: {
          if (status != "")
            'input': {
              'transaction_status': "${status}",
            }
        }));
    print('result');
    try {
      var response = await result.response;
      log('Response from transaction history: $response');
      if (response.errors.isEmpty) {
        var body3 = jsonDecode(response.data);
        print('Body3 data here: $body3');
        var body4 = jsonDecode(body3['listTransactions']);
        print('BODY 4 HERE: $body4');
        var body5 = body4['data'];
        print("body 5 here: ${body5}");
        transHistory.value = body5;
        return body5;
        // var body5 = jsonDecode(body4['data']);
        // print('BODY 5 HERE: $body5');

        //var body3 = jsonDecode(response.data);

        // callHistory.value = body6[0];
        //  print("list here: $callHistory");
      } else {
        return "ERROR";
      }
    } catch (e) {
      print("error: $e");
      return "ERROR";
    }
  }

  listProfession(master_profession_id) async {
    try {
      var url = Uri.parse(
          "https://6buq4qbi46.execute-api.ap-south-1.amazonaws.com/Any/list_professions");
      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'x-api-key': 'IjTmpS9QCM8QcrIZZ2pHy64TS6oPdw6A7In2K1M7',
          },
          body: jsonEncode({
            "command": "listProfessions",
            "profession_status": "ACTIVE",
            if (master_profession_id != "")
              "master_profession_id": "$master_profession_id"
          }));

      log("Listing professions response: ${response.body}");
      var body = jsonDecode(response.body);
      print("BODY1 it is: $body");
      var body2 = body['data']['items'];
      print('BODY2 it is : $body2');
      log("Body2: $body2 ");
      if (master_profession_id == "") {
        professionsList.value = body2;
      } else {
        subProfessionsList.value = body2;
      }

      print('prof LIST HERE FINAL: ${professionsList}');
      print('sub prof LIST HERE FINAL: ${subProfessionsList}');

      // var body3 = body2['']

      // if (body['status'] == "SUCCESS") {
      // log("cons ${body.runtimeType}");
      // log("cons ${body['body']['hits']['hits']}");
      // openSearcResult.value = body['body']['hits']['hits'];
      // print("open: ${openSearcResult.value}");
      // }
    } catch (e) {
      print(e);
    }
  }

  getConsultantDetails(consultant_id) async {
    print(' FINDINGGGG ${consultant_id}');
    var result = Amplify.API.query(
        request: GraphQLRequest(
            document:
                '''query GetConsultantDetails(\$input: getConsultantDetailsInput) {
  getConsultantDetails(input: \$input)
}
''',
            variables: {
          'input': {
            'consultant_id': "${consultant_id}",
          }
        }));
    try {
      var response = await result.response;
      print("error :${response.errors}");
      print(" getConsultantDetails response :${response.data}");
      var body1 = jsonDecode(response.data);
      //  print(' BODY 1 it is: $body1');
      log("Body1: $body1 ");
      var body2 = jsonDecode(body1['getConsultantDetails']);
      print(" Final body 2 $body2");
      var body3 = body2['data'];
      print('FINALL BODY 3 is $body3');
      log("BODY# $body3");
      // callhisConsultantDetails.value = body3;
      return body3;

      //   }
    } catch (e) {
      print("error: $e");
    }
  }

  deleteUser() async {
    var result = Amplify.API.query(
        request: GraphQLRequest(
      document: '''mutation DeleteUser {
  deleteUser
}
''',
    ));
    try {
      var response = await result.response;
      print("error :${response.errors}");
      print(" deleteUser API response :${response.data}");
      var body1 = jsonDecode(response.data);
      //  print(' BODY 1 it is: $body1');
      log("Body1: $body1 ");
      //  var body2 = jsonDecode(body1['getConsultantDetails']);
      // print(" Final body 2 $body2");
      // var body3 = body2['data'];
      // print('FINALL BODY 3 is $body3');
      // log("BODY# $body3");
      // // callhisConsultantDetails.value = body3;
      // return body3;

      //   }
    } catch (e) {
      print("error: $e");
    }
  }

  getExpertDetails(consultant_id) async {
    print("Experts Consultant ID: ${consultant_id}");
    try {
      var url = Uri.parse(
          "https://6buq4qbi46.execute-api.ap-south-1.amazonaws.com/Any/get_consultant_details");
      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'x-api-key': 'IjTmpS9QCM8QcrIZZ2pHy64TS6oPdw6A7In2K1M7',
          },
          body: jsonEncode({
            "consultant_id": "${consultant_id}",
          }));

      log("response from getExpertDetails: ${response.body}");
      var body = jsonDecode(response.body);

      // if (body['status'] == "SUCCESS") {
      // log("cons ${body.runtimeType}");
      // log("cons ${body['data']}");
      // openSearcResult.value = [];
      // openSearcResult.value = body['data'];
      // print("Searched Value: ${openSearcResult.value}");
      // }
    } catch (e) {
      print(e);
    }
  }

  getUserTransactionHistory() async {
    try {
      var result = Amplify.API.query(
          request: GraphQLRequest(
        document: '''query ListUserTransactions {
  listUserTransactions
}
''',
      ));
      var response = await result.response;
      var data = response.data;
      var errors = response.errors;
      log("Data $data");
      // log("Errors: $errors");
      if (response.data.isNotEmpty) {
        var body = jsonDecode(data);
        log("body :$body");
        var det = jsonDecode(body['listUserTransactions']);
        var responseTrans = det['data'];
        log("returnPiece $responseTrans");
        return responseTrans;
      } else {
        return "ERROR";
      }
    } catch (e) {
      log("error", error: e);
      return "ERROR";
    }
  }

  listUserCallHistory() async {
    try {
      var result = Amplify.API.query(
          request: GraphQLRequest(
        document: '''query ListUserCallHistory {
    listUserCallHistory
  }
''',
      ));
      var response = await result.response;
      var data = response.data;
      var errors = response.errors;
      // log("Data $data");
      // log("Errors: $errors");

      if (response.data.isNotEmpty) {
        var body = jsonDecode(data);
       // log("body :$body");
        var det = jsonDecode(body['listUserCallHistory']);
       // log("Detdet $det");
        var returnPiece = det['data'];
        //log("returnPiece $returnPiece");
        return returnPiece;
      } else {
        return "ERROR";
      }
    } catch (err) {
      return "ERROR";
    }
  }

  //Expert APis

  signup_as_consultant(name, profession, description, country, state, language,
      years, charge, phoneno, countrycode) async {
    print("Name: $name");
    print("Profession: $profession");
    print("Description: $description");
    print("Country: $country");
    print("State: $state");
    print("Name: $name");
    print("Language: $language");
    print("Years: $years");
    print("Charge: $charge");
    print("Phonenumber: $phoneno");

    print("Countrycode: $countrycode");
    try {
      var url = Uri.parse(
          "https://6buq4qbi46.execute-api.ap-south-1.amazonaws.com/Any/consultant_signup");
      var response = await http.post(
        url,
        body: jsonEncode({
          "consultant_name": "$name",
          "consultant_profession": "$profession",
          "consultant_description": "$description",
          "consultant_country": "$country",
          "consultant_state": "$state",
          // "consultant_profile_pic_url":
          //     "",
          "consultant_language": '$language',
          "consultant_experience": "$years",
          "consultant_charge_per_minute": "$charge",
          "consultant_phone_number": "$phoneno",
          "consultant_country_code": "$countrycode"
        }),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': 'IjTmpS9QCM8QcrIZZ2pHy64TS6oPdw6A7In2K1M7',
        },
      );
      var body = jsonDecode(response.body);
      print("body here: $body");
      if (body['Status'] == "SUCCESS") {
        print("success");
      } else {
        return "Fail";
      }
    } catch (e) {
      print("error: $e");
    }
  }

  getCurrentExpertDetails() async {
    try {
      var op = Amplify.API.query(
          request: GraphQLRequest(
        document: '''query GetCurrentExpertDetails {
  getCurrentExpertDetails
}
''',
      ));
      var response = await op.response;
      var data = response.data;
      var errors = response.errors;

      log("Response for currentExpert:, $data");
      log("Error from currentExpert :, $errors");
      if (data.isNotEmpty) {
        var temp = jsonDecode(data);
        // log("temp   $temp");
        var temp2 = jsonDecode(temp['getCurrentExpertDetails']);
        log("temp2temp2, $temp2");
        var returnValues = temp2['data'];
        User.userEmail.value = returnValues['expert_email_id'];
        User.expertname = returnValues['expert_name'];

        User.expertstatus = returnValues['profile_status'];

        User.expertCredits = returnValues['expert_credits'].toString();
        // print("Email L:${User.userEmail}");
        return returnValues;
      } else {
        return "ERROR";
      }
    } catch (e) {
      log("Errorr in current expert detail :", error: e);
      return "ERROR";
    }
  }

  bardAssistantModel(user_input) async {
    try {
      var result = Amplify.API.query(
          request: GraphQLRequest(
              document:
                  '''query BardAssistantModel(\$input: bardAssistantModelInput) {
    bardAssistantModel(input: \$input)
  }
''',
              variables: {
            'input': {
              'user_input': user_input,
            }
          }));
      var response = await result.response;
      var data = response.data;
      var errors = response.errors;
      // log("Data $data");
      // log("Errors: $errors");
      if (response.data.isNotEmpty) {
        var body = jsonDecode(data);
        log("body :$body");
        var det = jsonDecode(body['bardAssistantModel']);
        log("Detdet $det");
        var bardAIresp = det['data'];
        log("bardAIresp $bardAIresp");
        return bardAIresp;
      } else {
        return "ERROR";
      }
    } catch (err) {
      return "ERROR";
    }
  }

  listExpertCallHistory() async {
    try {
      var result = Amplify.API.query(
          request: GraphQLRequest(
        document: '''query ListExpertCallHistory {
    listExpertCallHistory
  }
''',
      ));
      var response = await result.response;
      var data = response.data;
      var errors = response.errors;
      // log("Data $data");
      // log("Errors: $errors");
      if (response.data.isNotEmpty) {
        var body = jsonDecode(data);
        log("body :$body");
        var det = jsonDecode(body['listExpertCallHistory']);
        log("Detdet $det");
        var returnPiece = det['data'];
        log("returnPiece $returnPiece");
        return returnPiece;
      } else {
        return "ERROR";
      }
    } catch (err) {
      return "ERROR";
    }
  }
  //  callHistory.value = body5;
  //       return body5;

  listExpertTransactions() async {
    try {
      var result = Amplify.API.query(
          request: GraphQLRequest(
        document: '''query ListExpertTransactions {
  listExpertTransactions
}
''',
      ));
      var response = await result.response;
      var data = response.data;
      var errors = response.errors;
      log("Data $data");
      // log("Errors: $errors");
      if (response.data.isNotEmpty) {
        var body = jsonDecode(data);
        log("body :$body");
        var det = jsonDecode(body['listExpertTransactions']);
        var returnPiece = det['data'];

        log("returnPiece $returnPiece");
        return returnPiece;
      } else {
        return "ERROR";
      }
    } catch (e) {
      return "ERROR";
    }
  }

  editConsumer(name, terms) async {
    try {
      var result = Amplify.API.query(
          request: GraphQLRequest(
              document: '''mutation EditConsumer(\$input: editConsumerInput) {
    editConsumer(input: \$input)
  }
''',
              variables: {
            'input': {
              if (name != "") 'consumer_name': name,
              'consumer_agreed_terms_and_conditions': terms,
              'action': "UPDATE"
            }
          }));
      var response = await result.response;
      var body = response.data;
      var errors = response.errors;
      print("bodyy: $body");
    } catch (e) {
      return "ERROR";
    }
  }

  toggleExpertAvailability(expert_is_online) async {
    try {
      var result = Amplify.API.query(
          request: GraphQLRequest(
              document:
                  '''mutation EditExpertOnlineStatus(\$input: editExpertOnlineStatusInput) {
    editExpertOnlineStatus(input: \$input)
  }
''',
              variables: {
            'input': {
              'expert_is_online': expert_is_online,
            }
          }));
      var response = await result.response;
      log("data ${response.data}");
      // log("Errors :${response.errors}");
      if (response.errors.isNotEmpty) {
        print("err: ${response.errors[0].message}");
        Fluttertoast.showToast(
            msg: "${response.errors[0].message}!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP_LEFT,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromARGB(255, 255, 0, 0),
            //  textColor: Colwhite,
            fontSize: 16.0);

        return "${response.errors[0].message}";
      } else {
        Fluttertoast.showToast(
            msg: (expert_is_online == true)
                ? "You are online!"
                : "going offline!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP_LEFT,
            timeInSecForIosWeb: 1,
            //    backgroundColor: Bluecolor,
            //  textColor: Colwhite,
            fontSize: 16.0);
        return "SUCCESS";
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP_LEFT,
          timeInSecForIosWeb: 1,
          //  backgroundColor: Bluecolor,
          // textColor: Colwhite,
          fontSize: 16.0);

      return "ERROR";
    }
  }

// url: "https://6buq4qbi46.execute-api.ap-south-1.amazonaws.com/Any/expert_signup_email",

  expert_signup_email(emailid) async {
    try {
      var url = Uri.parse(
          "https://6buq4qbi46.execute-api.ap-south-1.amazonaws.com/Any/expert_signup_email");
      var response = await http.post(url,
          headers: {
            // 'Content-Type': 'application/json',
            'x-api-key': 'IjTmpS9QCM8QcrIZZ2pHy64TS6oPdw6A7In2K1M7',
          },
          body: jsonEncode({
            "command": "signUpExpert",
            "expert_email_id": emailid,
          }));
      var body = jsonDecode(response.body);
      //print("exoert by id body: $body");

      log("Expert ID body1: $body");
      if (body['status'] == "SUCCESS") {
        print("Success");
        return "Success";
      } else {
        return "Error";
      }
      // log("response ,$body1");
    } catch (e) {
      return "Error";
    }
  }

  
  getExpertByDetailsByDisplayId(displayid) async {
    log("fkjhfd$displayid");
    try {
      var url = Uri.parse(
          "https://6buq4qbi46.execute-api.ap-south-1.amazonaws.com/Any/get_expert_details");
      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'x-api-key': 'IjTmpS9QCM8QcrIZZ2pHy64TS6oPdw6A7In2K1M7',
          },
          body: jsonEncode({
            "command": "getCurrentExpertDetailsByExpertId",
            "expert_display_id": "${displayid}",
          }));
      var body = jsonDecode(response.body);
      //print("exoert by id body: $body");

      var expertDet = body['data'];
      log("ByDisplayid response: $body");
      if (body['status'] == "Success" || body['status'] == "SUCCESS") {
        print("Success");
        return expertDet;
      } else {
        return "Error";
      }
      // log("response ,$body1");
    } catch (e) {
      return "Error";
    }
  }

  editExpert(
      expert_name,
      expert_email_id,
      expprof,
      expprof_id,
      expsubprof,
      expsubprof_id,
      expert_desc,
      exp_country,
      exp_state,
      exp_profilepic,
      exp_lang,
      exp_exp,
      exp_charge,
      chargetype,
      exp_phn,
      keyword) async {
    print("exp_profilepic :$exp_profilepic");
    print('edit name : $expert_name');
    print('edit email $expert_email_id');
    print('edit prof  $expprof  ');
    print('prof id : $expprof_id');
    print(' subprof id :  $expsubprof');
    print(' expsubprof id :  $expsubprof_id');
    print(' descri :  $expert_desc');
    print(' country:  $exp_country,');
    print(' state :  $exp_state');
    print(' lang :  $exp_lang');
    print(' expert exp :  $exp_exp');
    print(' expert charge:  $exp_charge');
    print('phone no:  $exp_phn');
    print('Charge type $chargetype');

    var result = Amplify.API.query(
        request: GraphQLRequest(
            document: '''mutation EditExpert(\$input: editExpertInput!) {
  editExpert(input: \$input)
}''',
            variables: {
          'input': {
            'expert_name': "$expert_name",
            'expert_email_id': "$expert_email_id",
            'expert_profession': expprof,
            'expert_profession_id': "${expprof_id}",
            if (expsubprof != "") 'expert_sub_profession': expsubprof,
            if (expsubprof_id != "") 'expert_sub_profession_id': expsubprof_id,
            'expert_long_description': expert_desc,
            'expert_country': exp_country,
            'expert_state': exp_state,
            if (exp_profilepic != "") 'expert_profile_pic_url': exp_profilepic,
            'expert_languages': exp_lang,
            'expert_experience': exp_exp,
            if (exp_charge != "") 'expert_charge_per_minute': exp_charge,
            'expert_charge_type': chargetype,
            'expert_phone_number': "+91$exp_phn",
            "search_keywords": keyword,
            'update_source': "Mobile",
            'action': "UPDATE"
          }
        }));
    try {
      var response = await result.response;
      var body = jsonDecode(response.data);
      print('Edit Expert body here: $body');
      var body1 = jsonDecode(body['editExpert']);
      print("body 1: $body1");
      var status = body1['status'];

      print("status: $status");

      if (status == "Success") {
        return "Success";
      } else {
        return "Error";
      }
    } catch (e) {
      print("Error in Edit Expert: $e");
      return 'Error';
    }
  }

  searchkeywords() async {
    try {
      var url = Uri.parse(
          "https://6buq4qbi46.execute-api.ap-south-1.amazonaws.com/Any/list_search_keywords");
      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'x-api-key': 'IjTmpS9QCM8QcrIZZ2pHy64TS6oPdw6A7In2K1M7',
          },
          body: jsonEncode({
            "command": "listSearchKeywords",
          }));
      var body = jsonDecode(response.body);
      //print("exoert by id body: $body");

      var keyword = body['data'];
      log("Searchkeyword: $keyword");
      print("bodyyy: $body");
      if (body['status'] == "SUCCESS") {
        print("Success");
        return keyword;
      } else {
        return "Error";
      }
    } catch (e) {
      return "Error";
    }
  }

  anyquiresettings() async {
    print("settings");
    try {
      var url = Uri.parse(
          "https://6buq4qbi46.execute-api.ap-south-1.amazonaws.com/Any/get_anyquire_settings");
      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'x-api-key': 'IjTmpS9QCM8QcrIZZ2pHy64TS6oPdw6A7In2K1M7',
          },
          body: jsonEncode({
            "command": "getAnyquireSettings",
            //is_server_under_maintainance
          }));
      var body = jsonDecode(response.body);
      //print("exoert by id body: $body");

      var settings = body['data'];
      log("Maintainance Settings: $settings");
      //print("bodyyy: $body");
      if (body['status'] == "SUCCESS") {
        print("Success");
        return settings;
      } else {
        return "Error";
      }
    } catch (e) {
      return "Error";
    }
  }
}
