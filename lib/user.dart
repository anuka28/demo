import 'package:get/get.dart';

class User {
  static String userCredits = "";
  static String name = "";
  static String expertname = "";

  static String consumerid = "";
  static String expertstatus = "";
  static String expertCredits = "";
  static String userPhonenumber = "";
  static RxList userdetails = [].obs;
  static RxString userEmail = "".obs;
  static RxString userExpertWalletBalance = "".obs;
  static bool is_anyquire_expert = false;
  static bool accept_terms = false;

  clear_user() {
    consumerid = "";
    expertstatus = "";
    name = "";
    expertname = "";
    expertCredits = '';
    userPhonenumber = "";
    userdetails.value = [];
    userCredits = "";
    userEmail.value = "";
  }
}
