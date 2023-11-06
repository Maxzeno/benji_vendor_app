import 'dart:convert';

import 'package:benji_vendor/src/controller/user_controller.dart';
import 'package:benji_vendor/src/model/package/item_category.dart';
import 'package:benji_vendor/src/model/package/item_weight.dart';
import 'package:benji_vendor/src/model/user_model.dart';
import 'package:benji_vendor/src/providers/api_url.dart';
import 'package:benji_vendor/src/providers/helper.dart';
import 'package:http/http.dart' as http;

class DeliveryItem {
  final String id;
  final UserModel clientId;
  final String pickUpAddress;
  final String senderName;
  final String senderPhoneNumber;
  final String dropOffAddress;
  final String receiverName;
  final String receiverPhoneNumber;
  final String itemName;
  final ItemCategory itemCategory;
  final ItemWeight itemWeight;
  final int itemQuantity;
  final int itemValue;
  final String? itemImage;
  final double prices;
  final String status;

  DeliveryItem({
    required this.id,
    required this.clientId,
    required this.pickUpAddress,
    required this.senderName,
    required this.senderPhoneNumber,
    required this.dropOffAddress,
    required this.receiverName,
    required this.receiverPhoneNumber,
    required this.itemName,
    required this.itemCategory,
    required this.itemWeight,
    required this.itemQuantity,
    required this.itemValue,
    required this.itemImage,
    required this.prices,
    required this.status,
  });

  factory DeliveryItem.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return DeliveryItem(
      id: json['id'] ?? notAvailable,
      clientId: UserModel.fromJson(json['client']),
      pickUpAddress: json['pickUpAddress'] ?? notAvailable,
      senderName: json['senderName'] ?? notAvailable,
      senderPhoneNumber: json['senderPhoneNumber'] ?? notAvailable,
      dropOffAddress: json['dropOffAddress'] ?? notAvailable,
      receiverName: json['receiverName'] ?? notAvailable,
      receiverPhoneNumber: json['receiverPhoneNumber'] ?? notAvailable,
      itemName: json['itemName'] ?? notAvailable,
      itemCategory: ItemCategory.fromJson(json['itemCategory']),
      itemWeight: ItemWeight.fromJson(json['itemWeight']),
      itemQuantity: json['itemQuantity'] ?? 0,
      itemValue: json['itemValue'] ?? notAvailable,
      itemImage: json['itemImage'],
      prices: json['prices'] ?? 0.0,
      status: json['status'] ?? notAvailable,
    );
  }
}

Future<List<DeliveryItem>> getDeliveryItemsByClientAndStatus(
    String status) async {
  UserModel? user = UserController.instance.user.value;
  final response = await http.get(
      Uri.parse(
          '$baseURL/sendPackage/gettemPackageByClientId/${user.id}/$status'),
      headers: authHeader());
  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((item) => DeliveryItem.fromJson(item))
        .toList();
  } else {
    return [];
  }
}

Future<DeliveryItem> getDeliveryItemById(id) async {
  final response = await http.get(
      Uri.parse('$baseURL/sendPackage/gettemPackageById/$id/'),
      headers: authHeader());

  if (response.statusCode == 200) {
    return DeliveryItem.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load delivery item');
  }
}
