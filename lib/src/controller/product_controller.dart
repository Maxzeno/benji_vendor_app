// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:benji_vendor/src/controller/error_controller.dart';
import 'package:benji_vendor/src/controller/user_controller.dart';
import 'package:benji_vendor/src/model/product_model.dart';
import 'package:benji_vendor/src/providers/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductrController extends GetxController {
  static ProductrController get instance {
    return Get.find<ProductrController>();
  }

  var isLoad = false.obs;
  var products = <Product>[].obs;

  var loadedAll = false.obs;
  var isLoadMore = false.obs;
  var loadNum = 10.obs;

  Future<void> scrollListener(scrollController) async {
    if (ProductrController.instance.loadedAll.value) {
      return;
    }

    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      ProductrController.instance.isLoadMore.value = true;
      update();
      await ProductrController.instance.getProducts();
    }
  }

  Future getProducts({
    bool first = false,
  }) async {
    if (first) {
      loadNum.value = 10;
    }
    if (loadedAll.value) {
      return;
    }
    if (!first) {
      isLoadMore.value = true;
    }
    isLoad.value = true;
    if (loadedAll.value) {
      return;
    }
    late String token;
    String id = UserController.instance.user.value.id.toString();
    var url =
        "${Api.baseUrl}/vendors/$id/listMyProducts?start=${loadNum.value - 10}&end=${loadNum.value}";
    loadNum.value += 10;
    token = UserController.instance.user.value.token;
    http.Response? response = await HandleData.getApi(url, token);
    var responseData = await ApiProcessorController.errorState(response);
    if (responseData == null) {
      if (!first) {
        isLoadMore.value = false;
      }
      isLoad.value = false;
      return;
    }
    List<Product> data = [];
    try {
      data = (jsonDecode(responseData)['items'] as List)
          .map((e) => Product.fromJson(e))
          .toList();
      products.value += data;
    } catch (e) {
      consoleLog(e.toString());
    }
    loadedAll.value = data.isEmpty;
    isLoad.value = false;
    isLoadMore.value = false;
    update();
  }
}
