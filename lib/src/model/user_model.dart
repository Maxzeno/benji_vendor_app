// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:benji_vendor/src/providers/helper.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int id;
  String code;
  String email;
  String phone;
  String username;
  String firstName;
  String lastName;
  String address;
  String gender;
  String religion;
  String worshipHours;
  String stateOfOrigin;
  String lga;
  String permanentAddress;
  String residentialAddress;
  String nearestBusStop;
  String maritalStatus;
  String nameOfSpouse;
  String phoneNumberOfSpouse;
  String license;
  String token;
  String image;

  UserModel({
    required this.id,
    required this.email,
    required this.phone,
    required this.code,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.gender,
    required this.religion,
    required this.worshipHours,
    required this.stateOfOrigin,
    required this.lga,
    required this.permanentAddress,
    required this.residentialAddress,
    required this.nearestBusStop,
    required this.maritalStatus,
    required this.nameOfSpouse,
    required this.phoneNumberOfSpouse,
    required this.license,
    required this.token,
    required this.image,
  });
  factory UserModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? notAvailable,
      phone: json['phone'] ?? notAvailable,
      code: json['code'] ?? notAvailable,
      username: json['username'] ?? notAvailable,
      firstName: json['first_name'] ?? notAvailable,
      lastName: json['last_name'] ?? notAvailable,
      address: json['address'] ?? notAvailable,
      gender: json['gender'] ?? notAvailable,
      religion: json['religion'] ?? notAvailable,
      worshipHours: json['worship_hours'] ?? notAvailable,
      stateOfOrigin: json['stateOfOrigin'] ?? notAvailable,
      lga: json['lga'] ?? notAvailable,
      permanentAddress: json['permanent_address'] ?? notAvailable,
      residentialAddress: json['residential_address'] ?? notAvailable,
      nearestBusStop: json['nearest_bus_stop'] ?? notAvailable,
      maritalStatus: json['marital_status'] ?? notAvailable,
      nameOfSpouse: json['nameOfSpouse'] ?? notAvailable,
      phoneNumberOfSpouse: json['phoneNumberOfSpouse'] ?? notAvailable,
      license: json['license'] ?? notAvailable,
      token: json['token'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "phone": phone,
        "code": code,
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "address": address,
        "gender": gender,
        "religion": religion,
        "worship_hours": worshipHours,
        "stateOfOrigin": stateOfOrigin,
        "lga": lga,
        "permanent_address": permanentAddress,
        "residential_address": residentialAddress,
        "nearest_bus_stop": nearestBusStop,
        "marital_status": maritalStatus,
        "nameOfSpouse": nameOfSpouse,
        "phoneNumberOfSpouse": phoneNumberOfSpouse,
        "license": license,
        "token": token,
        "image": image,
      };
}
