import 'dart:convert';

import 'package:benji_vendor/src/model/business_type_model.dart';
import 'package:benji_vendor/src/providers/helper.dart';
import 'package:get/get.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int id;
  String token;
  String email;
  String phone;
  String username;
  String code;
  String firstName;
  String lastName;
  String gender;
  String address;
  String longitude;
  String latitude;
  bool isOnline;
  double averageRating;
  int numberOfClientsReactions;
  String shopName;
  String shopImage;
  String profileLogo;
  BusinessType shopType;
  String weekOpeningHours;
  String weekClosingHours;
  String satOpeningHours;
  String satClosingHours;
  String sunWeekOpeningHours;
  String sunWeekClosingHours;
  // String businessBio;

  UserModel({
    required this.id,
    required this.token,
    required this.email,
    required this.phone,
    required this.username,
    required this.code,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.address,
    required this.longitude,
    required this.latitude,
    required this.isOnline,
    required this.averageRating,
    required this.numberOfClientsReactions,
    required this.shopName,
    required this.shopImage,
    required this.profileLogo,
    required this.shopType,
    required this.weekOpeningHours,
    required this.weekClosingHours,
    required this.satOpeningHours,
    required this.satClosingHours,
    required this.sunWeekOpeningHours,
    required this.sunWeekClosingHours,
    // required this.businessBio,
  });

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return UserModel(
      id: json["id"] ?? 0,
      token: json["token"] ?? '',
      email: json["email"] ?? notAvailable,
      phone: json["phone"] ?? notAvailable,
      username: json["username"] ?? notAvailable,
      code: json["code"] ?? notAvailable,
      firstName: json["first_name"] ?? notAvailable,
      lastName: json["last_name"] ?? notAvailable,
      gender: json["gender"] ?? notAvailable,
      address: json["address"] ?? notAvailable,
      longitude: json["longitude"] ?? notAvailable,
      latitude: json["latitude"] ?? notAvailable,
      isOnline: json["is_online"] ?? false,
      averageRating: ((json["average_rating"] ?? 0.0) as double).toPrecision(1),
      numberOfClientsReactions: json["number_of_clients_reactions"] ?? 0,
      shopName: json["shop_name"] ?? notAvailable,
      shopImage: json["shop_image"] ?? '',
      profileLogo: json["profileLogo"] ?? '',
      shopType: BusinessType.fromJson(json["shop_type"]),
      weekOpeningHours: json["weekOpeningHours"] ?? notAvailable,
      weekClosingHours: json["weekClosingHours"] ?? notAvailable,
      satOpeningHours: json["satOpeningHours"] ?? notAvailable,
      satClosingHours: json["satClosingHours"] ?? notAvailable,
      sunWeekOpeningHours: json["sunWeekOpeningHours"] ?? notAvailable,
      sunWeekClosingHours: json["sunWeekClosingHours"] ?? notAvailable,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "token": token,
        "email": email,
        "phone": phone,
        "username": username,
        "code": code,
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender,
        "address": address,
        "is_online": isOnline,
        "average_rating": averageRating,
        "number_of_clients_reactions": numberOfClientsReactions,
        "shop_name": shopName,
        "shop_image": shopImage,
        "profileLogo": profileLogo,
        "shop_type": shopType.toJson(),
        "weekOpeningHours": weekOpeningHours,
        "weekClosingHours": weekClosingHours,
        "satOpeningHours": satOpeningHours,
        "satClosingHours": satClosingHours,
        "sunWeekOpeningHours": sunWeekOpeningHours,
        "sunWeekClosingHours": sunWeekClosingHours
        // "businessBio": businessBio,
      };
}
