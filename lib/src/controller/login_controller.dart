// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';

import 'package:benji_vendor/app/splash_screens/login_splash_screen.dart';
import 'package:benji_vendor/src/controller/error_controller.dart';
import 'package:benji_vendor/src/controller/user_controller.dart';
import 'package:benji_vendor/src/model/login_model.dart';
import 'package:benji_vendor/src/providers/api_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  static LoginController get instance {
    return Get.find<LoginController>();
  }

  var isLoad = false.obs;

  Future<void> login(SendLogin data) async {
    try {
      UserController.instance;
      isLoad.value = true;
      update();
      Map finalData = {
        "username": data.username,
        "password": data.password,
      };

      http.Response? response =
          await HandleData.postApi(Api.baseUrl + Api.login, null, finalData);

      if (response == null || response.statusCode != 200) {
        if (response!.statusCode == 502) {
          ApiProcessorController.errorSnack(
              "We are currently experiencing a downtime. Please try again later");
          isLoad.value = false;
          update();
          return;
        }
        ApiProcessorController.errorSnack(
            "Invalid email or password. Try again");
        isLoad.value = false;
        update();
        return;
      }

      var jsonData = jsonDecode(response.body);

      if (jsonData["token"] == false) {
        ApiProcessorController.errorSnack(
            "Invalid email or password. Try again");
        isLoad.value = false;
        update();
      } else {
        http.Response? responseUser =
            await HandleData.getApi(Api.baseUrl + Api.user, jsonData["token"]);
        if (responseUser == null || responseUser.statusCode != 200) {
          ApiProcessorController.errorSnack(
              "Invalid email or password. Try again");
          isLoad.value = false;
          update();
          return;
        }

        http.Response? responseUserData = await HandleData.getApi(
            Api.baseUrl +
                Api.getSpecificVendor +
                jsonDecode(responseUser.body)['id'].toString(),
            jsonData["token"]);
        if (responseUserData == null || responseUserData.statusCode != 200) {
          ApiProcessorController.errorSnack(
              "Invalid email or password. Try again");
          isLoad.value = false;
          update();
          return;
        }

        UserController.instance
            .saveUser(responseUserData.body, jsonData["token"]);
        isLoad.value = false;
        update();
        ApiProcessorController.successSnack("Login Successful");
        Get.offAll(
          () => LoginSplashScreen(),
          fullscreenDialog: true,
          curve: Curves.easeIn,
          routeName: "LoginSplashScreen",
          predicate: (route) => false,
          popGesture: true,
          transition: Transition.cupertinoDialog,
        );
        return;
      }
    } catch (e) {
      ApiProcessorController.errorSnack("Invalid email or password. Try again");
      isLoad.value = false;
      update();
    }
  }
}
