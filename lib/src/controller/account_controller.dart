import 'dart:convert';
import 'dart:io';

import 'package:benji_vendor/account_model.dart';
import 'package:benji_vendor/src/controller/error_controller.dart';
import 'package:benji_vendor/src/controller/user_controller.dart';
import 'package:benji_vendor/src/providers/api_url.dart';
import 'package:benji_vendor/src/providers/helpers.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AccountController extends GetxController {
  static AccountController get instance {
    return Get.find<AccountController>();
  }

  var isLoad = false.obs;
  var accounts = <AccountModel>[].obs;

  getAccounts() async {
    var userId = UserController.instance.user.value.id;
    var url = "${Api.baseUrl}/payments/getSaveBankDetails/$userId/";
    isLoad.value = true;
    update();
    try {
      final response = await http.get(Uri.parse(url), headers: authHeader());

      if (response.statusCode == 200) {
        dynamic jsonResponse = jsonDecode(response.body);
        accounts.value = AccountModel.listFromJson(
            (jsonResponse as List).cast<Map<String, dynamic>>());
      }
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
    } catch (e) {
      accounts.value = [];
    }
    isLoad.value = false;
    update();
  }
}
