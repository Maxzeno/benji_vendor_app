// ignore_for_file: empty_catches

import 'dart:convert';
import 'dart:io';

import 'package:benji_vendor/src/controller/error_controller.dart';
import 'package:benji_vendor/src/providers/helper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FormController extends GetxController {
  static FormController get instance {
    return Get.find<FormController>();
  }

  var isLoad = false.obs;
  var status = 0.obs;
  var responseObject = {}.obs;

  Future getAuth(String url, String tag,
      [String errorMsg = "Error occurred"]) async {
    isLoad.value = true;
    update([tag]);
    final response = await http.get(
      Uri.parse(url),
      headers: authHeader(),
    );
    status.value = response.statusCode;
    update([tag]);
    if (response.statusCode != 200) {
      ApiProcessorController.errorSnack(errorMsg);
      isLoad.value = false;
      update([tag]);
      return;
    }

    responseObject.value = (jsonDecode(response.body) as Map);
    isLoad.value = false;
    update([tag]);
  }

  Future deleteAuth(String url, String tag,
      [String errorMsg = "Error occurred",
      String successMsg = "Submitted successfully"]) async {
    isLoad.value = true;
    update([tag]);
    final response = await http.delete(
      Uri.parse(url),
      headers: authHeader(),
    );
    status.value = response.statusCode;
    update([tag]);
    if (response.statusCode != 200) {
      ApiProcessorController.errorSnack(errorMsg);
      isLoad.value = false;
      update([tag]);
      return;
    }

    ApiProcessorController.successSnack(successMsg);
    isLoad.value = false;
    update([tag]);
  }

  Future postAuth(String url, Map data, String tag,
      [String errorMsg = "Error occurred",
      String successMsg = "Submitted successfully"]) async {
    isLoad.value = true;
    update([tag]);
    final response = await http.post(
      Uri.parse(url),
      headers: authHeader(),
      body: data,
    );
    status.value = response.statusCode;
    if (response.statusCode != 200) {
      ApiProcessorController.errorSnack(errorMsg);
      isLoad.value = false;
      update([tag]);
      return;
    }

    ApiProcessorController.successSnack(successMsg);
    isLoad.value = false;
    responseObject.value = jsonDecode(response.body) as Map;
    update([tag]);
  }

  Future postNoAuth(String url, Map data, String tag,
      [String errorMsg = "Error occurred",
      String successMsg = "Submitted successfully"]) async {
    isLoad.value = true;
    update([tag]);
    final response = await http.post(
      Uri.parse(url),
      body: data,
    );
    status.value = response.statusCode;
    if (response.statusCode != 200) {
      ApiProcessorController.errorSnack(errorMsg);
      isLoad.value = false;
      update([tag]);
      return;
    }

    ApiProcessorController.successSnack(successMsg);
    isLoad.value = false;
    responseObject.value = jsonDecode(response.body) as Map;
    update([tag]);
  }

  Future postAuthstream(
      String url, Map data, Map<String, File?> files, String tag,
      [String errorMsg = "Error occurred",
      String successMsg = "Submitted successfully"]) async {
    http.StreamedResponse? response;

    isLoad.value = true;
    update([tag]);

    var request = http.MultipartRequest("POST", Uri.parse(url));
    Map<String, String> headers = authHeader();

    for (String key in files.keys) {
      if (files[key] == null) {
        continue;
      }
      request.files
          .add(await http.MultipartFile.fromPath(key, files[key]!.path));
    }

    request.headers.addAll(headers);

    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });
    print('stream response $response');
    try {
      response = await request.send();
      status.value = response.statusCode;
      final normalResp = await http.Response.fromStream(response);
      print('stream response ${normalResp.body}');
      if (response.statusCode != 200) {
        ApiProcessorController.successSnack(successMsg);
        isLoad.value = false;
        update([tag]);
        return;
      }
    } catch (e) {
      response = null;
    }

    ApiProcessorController.errorSnack(errorMsg);
    isLoad.value = false;
    update([tag]);
    return;
  }
}
