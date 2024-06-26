import 'dart:convert';
import 'dart:io';

import 'package:benji_vendor/src/controller/error_controller.dart';
import 'package:benji_vendor/src/providers/api_url.dart';
import 'package:benji_vendor/src/providers/helpers.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PaymentController extends GetxController {
  static PaymentController get instance {
    return Get.find<PaymentController>();
  }

  var isLoad = false.obs;
  var responseObject = {}.obs;

  Future<void> getDeliveryFee(String packageId) async {
    isLoad.value = true;
    update();

    try {
      final response = await http.get(
        Uri.parse('${Api.baseUrl}/payments/getdeliveryfee/$packageId/package'),
        headers: authHeader(),
      );
      if (response.statusCode == 200) {
        final dynamic decodedBody = jsonDecode(response.body);

        responseObject.value = (decodedBody as Map);
        update();
        return;
        // consoleLog(responseObject.value.toString());
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet.");
    } catch (error) {
      consoleLog('Error in getDeliveryFee: $error');
      ApiProcessorController.errorSnack(
          'Error in getting the delivery fee.\n ERROR: $error');
    } finally {
      isLoad.value = false;
      update();
    }
  }
}
