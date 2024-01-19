// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:benji_vendor/src/controller/user_controller.dart';
import 'package:benji_vendor/src/model/vendor_business.dart';
import 'package:benji_vendor/src/providers/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../providers/helper.dart';

class BusinessController extends GetxController {
  static BusinessController get instance {
    return Get.find<BusinessController>();
  }

  var isLoad = false.obs;
  var businesses = <BusinessModel>[].obs;

  Future getVendorBusinesses() async {
    isLoad.value = true;

    String userId = UserController.instance.user.value.id.toString();

    String url = Api.baseUrl + Api.getVendorBusinesses + userId;
    var parsedURL = Uri.parse(url);

    try {
      var response = await http.get(
        parsedURL,
        headers: authHeader(),
      );

      if (response.statusCode == 200) {
        businesses.value = (jsonDecode(response.body) as List)
            .map((item) => BusinessModel.fromJson(item))
            .toList();
      }
    } catch (e) {
      consoleLog(e.toString());
    }
    isLoad.value = false;
    update();
  }
}
