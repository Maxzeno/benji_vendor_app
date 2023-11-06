// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:benji_vendor/app/orders/orders.dart';
import 'package:benji_vendor/src/controller/error_controller.dart';
import 'package:benji_vendor/src/controller/user_controller.dart';
import 'package:benji_vendor/src/model/order.dart';
import 'package:benji_vendor/src/providers/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OrderController extends GetxController {
  static OrderController get instance {
    return Get.find<OrderController>();
  }

  var isLoad = false.obs;
  var orderList = <Order>[].obs;

  var loadedAll = false.obs;
  var isLoadMore = false.obs;
  var loadNum = 10.obs;
  var total = 0.obs;
  var status = StatusType.delivered.obs;

  Future<void> scrollListener(scrollController) async {
    if (OrderController.instance.loadedAll.value) {
      return;
    }

    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      OrderController.instance.isLoadMore.value = true;
      update();
      await OrderController.instance.getOrdersBy();
    }
  }

  setStatus([StatusType newStatus = StatusType.delivered]) async {
    status.value = newStatus;
    orderList.value = [];
    loadNum.value = 10;
    loadedAll.value = false;
    update();
    await getOrdersBy();
  }

  Future getTotal() async {
    late String token;
    String id = UserController.instance.user.value.id.toString();
    var url = "${Api.baseUrl}${Api.orderList}$id/listMyOrders?start=0&end=1";
    token = UserController.instance.user.value.token;
    http.Response? response = await HandleData.getApi(url, token);

    try {
      total.value = jsonDecode(response?.body ?? '{}')['total'];
    } catch (e) {
      total.value = 0;
      consoleLog(e.toString());
    }
    update();
  }

  Future getOrdersBy() async {
    if (loadedAll.value) {
      return;
    }
    isLoad.value = true;
    late String token;
    String id = UserController.instance.user.value.id.toString();
    var url =
        "${Api.baseUrl}${Api.orderList}$id/listMyOrders?start=${loadNum.value - 10}&end=${loadNum.value}";
    loadNum.value += 10;
    token = UserController.instance.user.value.token;
    http.Response? response = await HandleData.getApi(url, token);
    var responseData = await ApiProcessorController.errorState(response);
    if (responseData == null) {
      isLoad.value = false;
      loadedAll.value = true;
      isLoadMore.value = false;
      update();
      return;
    }
    List<Order> data = [];
    try {
      data = (jsonDecode(responseData)['items'] as List)
          .map((e) => Order.fromJson(e))
          .toList();
      orderList.value += data;
    } catch (e) {
      consoleLog(e.toString());
    }
    loadedAll.value = data.isEmpty;
    isLoad.value = false;
    isLoadMore.value = false;
    update();
  }
}