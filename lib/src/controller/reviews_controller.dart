// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:benji_vendor/src/controller/user_controller.dart';
import 'package:benji_vendor/src/model/rating_model.dart';
import 'package:benji_vendor/src/providers/api_url.dart';
import 'package:benji_vendor/src/providers/helper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ReviewsController extends GetxController {
  static ReviewsController get instance {
    return Get.find<ReviewsController>();
  }

  var isLoad = false.obs;
  var ratingValue = 0.obs;
  var avgRating = 0.0.obs;
  var reviews = <Ratings>[].obs;

  Future<void> scrollListener(scrollController, [int value = 0]) async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setRatingValue(value);
    }
  }

  getAvgRating() {
    double total = 0.0;
    for (Ratings review in reviews) {
      total += review.ratingValue;
    }
    avgRating.value = total;
    update();
  }

  Future setRatingValue([int value = 0]) async {
    ratingValue.value = value;
    update();
    await getReviews();
  }

  Future getReviews([int? value]) async {
    isLoad.value = true;

    try {
      reviews.value =
          await getRatingsByVendorIdAndOrRating(value ?? ratingValue.value);
      print(reviews.value);
    } catch (e) {
      consoleLog(e.toString());
    }
    isLoad.value = false;
    update();
  }

  Future<List<Ratings>> getRatingsByVendorIdAndOrRating(int rating,
      {start = 0, end = 100}) async {
    int id = UserController.instance.user.value.id;

    // url to be changed to vendor endpoint
    late http.Response response;
    if (rating != 0) {
      response = await http.get(
        Uri.parse(
            '$baseURL/clients/filterVendorReviewsByRating/$id?rating_value=$rating'),
        headers: authHeader(),
      );
      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((item) => Ratings.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } else {
      response = await http.get(
        Uri.parse(
            '$baseURL/vendors/$id/getAllVendorRatings?start=$start&end=$end'),
        headers: authHeader(),
      );
      if (response.statusCode == 200) {
        return (jsonDecode(response.body)['items'] as List)
            .map((item) => Ratings.fromJson(item))
            .toList();
      } else {
        return [];
      }
    }
  }
}
