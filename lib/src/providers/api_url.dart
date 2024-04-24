import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../controller/user_controller.dart';

// API URLS AND HTTP CALL FUNCTIONS
const baseURL = "https://resource.bgbot.app/api/v1";
const baseImage = "https://resource.bgbot.app";

var vendorId = UserController.instance.user.value.id;

class Api {
  static const baseUrl = "https://resource.bgbot.app/api/v1";
  static const login = "/auth/token";
  static const user = "/auth/";
  static const changePassword = "/auth/changeNewPassword/";
  static const addProduct = "/products/addProduct";
  static const changeProduct = "/products/changeProduct/";
  static const deleteProduct = "/products/deleteProduct/";
  static const notification = "/vendors/";
  static const category = "/categories/list";
  static const withdrawalHistory = "/wallet/withdrawalHistory/";
  static const changeProductImage = "/products/updateProductImage/";

  static const listBanks = "/payments/list_banks/";
  static const validateBankNumber = "/payments/validateBankNumbers/";
//Orders
  static const changeOrderStatus = "/orders/vendorChangeStatus";

//Vendor
  static const getSpecificVendor = "/vendors/getVendor/";
  static const vendorsOrderList = "/vendors/";
  static const changeVendorPersonalProfile =
      "/vendors/changeVendorpersonalprofile/";

  //Businesses
  static const getVendorBusinesses = "/vendors/getVendorBusinesses/";
  static const changeVendorBusinessProfile =
      "/vendors/changeVendorbusinessprofile/";

//Item Packages
  static const getPackageCategory = "/sendPackage/getPackageCategory/";
  static const getPackageWeight = "/sendPackage/getPackageWeight/";
  static const createItemPackage = "/sendPackage/createItemPackage/";
  static const dispatchPackage = "/sendPackage/changePackageStatus";
  static const reportPackage = "/clients/clientReportPackage/";

//Payments
  static const getDeliveryFee = "/payments/getdeliveryfee/";

  //BusinessTypes
  static const businessType = "/categories/list";

  //Push Notification
  static const createPushNotification = "/notifier/create_push_notification";
}

String header = "application/json";
const content = "application/x-www-form-urlencoded";

class HandleData {
  static Future<http.Response?> postApi([
    String? url,
    String? token,
    dynamic body,
  ]) async {
    http.Response? response;
    try {
      if (token == null) {
        response = await http
            .post(
              Uri.parse(url!),
              headers: {
                HttpHeaders.contentTypeHeader: header,
                "Content-Type": content,
              },
              body: body,
            )
            .timeout(const Duration(seconds: 50));
      } else {
        response = await http
            .post(
              Uri.parse(url!),
              headers: {
                HttpHeaders.contentTypeHeader: header,
                "Content-Type": content,
                HttpHeaders.authorizationHeader: "Bearer $token",
              },
              body: jsonEncode(body),
            )
            .timeout(const Duration(seconds: 50));
      }
    } catch (e) {
      response = null;
      consoleLog(e.toString());
    }
    return response;
  }

  static Future<http.Response?> getApi([
    String? url,
    String? token,
  ]) async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse(url!),
        headers: {
          HttpHeaders.contentTypeHeader: header,
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
    } catch (e) {
      response = null;
      consoleLog(e.toString());
    }
    return response;
  }

  static Future put() async {}
  static Future delete() async {}
}

void consoleLog(String val) {
  for (var i = 0; i < val.length; i += 1024) {
    debugPrint(val.substring(i, i + 1024 < val.length ? i + 1024 : val.length));
  }
}

void consoleLogToFile(String val) {
  File('log.txt').writeAsStringSync(val);
}
