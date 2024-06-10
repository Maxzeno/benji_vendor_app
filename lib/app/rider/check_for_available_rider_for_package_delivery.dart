import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/button/my elevatedButton.dart';
import '../../src/components/button/my outlined elevatedButton.dart';
import '../../src/controller/error_controller.dart';
import '../../src/controller/payment_controller.dart';
import '../../src/controller/user_controller.dart';
import '../../src/model/rider.dart';
import '../../src/providers/api_url.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';
import '../packages/packages_draft.dart';
import '../packages/pay_for_delivery.dart';

class CheckForAvailableRiderForPackageDelivery extends StatefulWidget {
  final dynamic packageId;
  final String senderName,
      senderPhoneNumber,
      receiverName,
      receiverPhoneNumber,
      dropOff,
      itemName,
      itemQuantity,
      itemWeight,
      itemValue,
      itemCategory;

  const CheckForAvailableRiderForPackageDelivery({
    super.key,
    this.packageId,
    required this.senderName,
    required this.senderPhoneNumber,
    required this.receiverName,
    required this.receiverPhoneNumber,
    required this.dropOff,
    required this.itemName,
    required this.itemQuantity,
    required this.itemWeight,
    required this.itemValue,
    required this.itemCategory,
  });

  @override
  State<CheckForAvailableRiderForPackageDelivery> createState() =>
      _CheckForAvailableRiderForPackageDeliveryState();
}

class _CheckForAvailableRiderForPackageDeliveryState
    extends State<CheckForAvailableRiderForPackageDelivery> {
  @override
  void initState() {
    super.initState();
    getAvailableRiders();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isLoading = false;
  bool ridersAreAvailable = false;

  Future<List<Rider>> getAvailableRiders() async {
    setState(() {
      isLoading = true;
    });
    var url = "${Api.baseUrl}/tasks/listAvailableRidersForTask";
    String token = UserController.instance.user.value.token;
    http.Response? response = await HandleData.getApi(url, token);
    var responseData = await ApiProcessorController.errorState(response);
    log(response!.body.toString());
    if (responseData == null) {
      setState(() {
        ridersAreAvailable = false;
      });
      return [];
    }
    List<Rider> data = [];
    try {
      data = (jsonDecode(response.body) as List)
          .map((e) => Rider.fromJson(e))
          .toList();
      log('the rider data');
      log("$data");
      setState(() {
        ridersAreAvailable = true;
      });
    } catch (e) {
      log(e.toString());
    }
    setState(() {
      isLoading = false;
    });
    return data;
  }

  gotToPackagePaymentScreen() async {
    await PaymentController.instance.getDeliveryFee(widget.packageId);
    await Get.to(
      () => PayForDelivery(
        packageId: widget.packageId,
        senderName: widget.senderName,
        senderPhoneNumber: widget.senderPhoneNumber,
        receiverName: widget.receiverName,
        receiverPhoneNumber: widget.receiverPhoneNumber,
        receiverLocation: widget.dropOff,
        itemName: widget.itemName,
        itemQuantity: widget.itemQuantity,
        itemWeight: widget.itemWeight,
        itemValue: widget.itemValue,
        itemCategory: widget.itemCategory,
      ),
      routeName: 'PayForDelivery',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: MyAppBar(
        title: "",
        elevation: 0,
        actions: const [],
        backgroundColor: kPrimaryColor,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            isLoading
                ? Column(
                    children: [
                      Lottie.asset(
                        "assets/animations/delivery/frame_4.json",
                        height: media.height * .6,
                        width: media.width,
                      ),
                      kSizedBox,
                      const Center(
                        child: Text(
                          "Checking for availability of riders...\nPlease wait a moment.",
                          maxLines: 10,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: kTextBlackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!ridersAreAvailable)
                        SizedBox(
                          width: media.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: media.height * .6,
                                width: media.width,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      "assets/images/rider/rider.png",
                                    ),
                                  ),
                                ),
                              ),
                              kSizedBox,
                              const Center(
                                child: Icon(
                                  Icons.warning_amber_outlined,
                                  color: kErrorColor,
                                  size: 38,
                                ),
                              ),
                              kHalfSizedBox,
                              const Center(
                                child: Text(
                                  "Riders are unavailable at the moment to handle your delivery.\n Please check in again later.",
                                  maxLines: 10,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: kDefaultPadding * 4),
                              MyOutlinedElevatedButton(
                                title: "Proceed",
                                onPressed: () {
                                  Get.off(
                                    () => const PackagesDraft(),
                                    routeName: 'PackagesDraft',
                                    duration: const Duration(milliseconds: 300),
                                    fullscreenDialog: true,
                                    curve: Curves.easeIn,
                                    preventDuplicates: true,
                                    popGesture: true,
                                    transition: Transition.rightToLeft,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      if (ridersAreAvailable)
                        SizedBox(
                          width: media.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: media.height * .6,
                                width: media.width,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      "assets/images/rider/rider.png",
                                    ),
                                  ),
                                ),
                              ),
                              kSizedBox,
                              const Center(
                                child: Icon(
                                  Icons.check_circle_outline_sharp,
                                  color: kSuccessColor,
                                  size: 38,
                                ),
                              ),
                              kHalfSizedBox,
                              const Center(
                                child: Text(
                                  "Riders are available to handle this delivery,\nyou can now proceed to pay.",
                                  maxLines: 10,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: kDefaultPadding * 4),
                              MyElevatedButton(
                                title: "Proceed",
                                onPressed: gotToPackagePaymentScreen,
                              ),
                            ],
                          ),
                        ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
