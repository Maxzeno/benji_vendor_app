// ignore_for_file: use_build_context_synchronously, unused_field

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_squad/flutter_squad.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';

import '../../src/components/appbar/my appbar.dart';
import '../../src/components/button/my elevatedButton.dart';
import '../../src/controller/auth_controller.dart';
import '../../src/controller/error_controller.dart';
import '../../src/controller/payment_controller.dart';
import '../../src/controller/push_notifications_controller.dart';
import '../../src/controller/user_controller.dart';
import '../../src/providers/api_url.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

class PayForDelivery extends StatefulWidget {
  final String packageId,
      senderName,
      senderPhoneNumber,
      receiverName,
      receiverPhoneNumber,
      receiverLocation,
      itemName,
      itemQuantity,
      itemWeight,
      itemCategory,
      itemValue;

  const PayForDelivery({
    super.key,
    required this.packageId,
    required this.senderName,
    required this.senderPhoneNumber,
    required this.receiverName,
    required this.receiverPhoneNumber,
    required this.receiverLocation,
    required this.itemName,
    required this.itemQuantity,
    required this.itemWeight,
    required this.itemValue,
    required this.itemCategory,
  });

  @override
  State<PayForDelivery> createState() => _PayForDeliveryState();
}

class _PayForDeliveryState extends State<PayForDelivery> {
  //=================================== INITIAL STATE ==========================================\\
  @override
  void initState() {
    super.initState();
    getUserData();
    getTotalPrice();
    callGetDeliveryFee();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // });
    packageData = <String>[
      widget.senderName,
      "$countryDialCode ${widget.senderPhoneNumber}",
      widget.receiverName,
      "$countryDialCode ${widget.receiverPhoneNumber}",
      widget.receiverLocation,
      widget.itemName,
      widget.itemWeight,
      widget.itemCategory,
      widget.itemQuantity,
      "₦ ${widget.itemValue}"
    ];
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }
  //=================================== ALL VARIABLES ==========================================\\

  // Map? _data;
  String countryDialCode = '+234';
  // final double subTotal = 0
  double totalPrice = 0;
  int deliveryFee =
      PaymentController.instance.responseObject.containsKey('delivery_fee')
          ? PaymentController.instance.responseObject['delivery_fee']
          : 0;
  double serviceFee = 0;
  String? userFirstName;
  String? userLastName;
  String? userEmail;
  final String paymentDescription = "Benji app delivery";
  final String currency = "NGN";

  // double insuranceFee = 0;
  // double discountFee = 0;
  getTotalPrice() {
    totalPrice = deliveryFee + serviceFee;
  }

  final List<String> titles = <String>[
    "Sender's name",
    "Sender's phone number",
    "Receiver's name",
    "Receiver's phone number",
    "Receiver's location",
    "Item name",
    "Item weight",
    "Item category",
    "Item quantity",
    "Item value",
  ];
  List<String>? packageData;

  //===================== GlobalKeys =======================\\

  final scaffoldKey = GlobalKey<ScaffoldState>();

  //===================== CONTROLLERS =======================\\

  final scrollController = ScrollController();

  //===================== BOOL VALUES =======================\\

  //===================== FUNCTIONS =======================\\

  Future<void> callGetDeliveryFee() async {
    await PaymentController.instance.getDeliveryFee(widget.packageId);
  }

//======== Place Order =======\\
  Future<void> placeOrder() async {
    try {
      SquadTransactionResponse? response = await Squad.checkout(
        context,
        charge(),
        sandbox: true,
        showAppbar: false,
        appBar: AppBarConfig(
          color: kAccentColor,
          leadingIcon: const FaIcon(FontAwesomeIcons.solidCircleXmark),
        ),
      );

      if (response != null && response.status.toString().startsWith("2")) {
        await PushNotificationController.showNotification(
          title: "Payment Successful ✅",
          body: "You have successfully paid for the delivery.",
          summary: "Package Delivery",
          largeIcon: "asset://assets/icons/package-success.png",
        );
        Get.close(3);
      }
      debugPrint(
        "Squad transaction completed======>${response?.toJson().toString()}",
      );
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
    } catch (e) {
      consoleLog(e.toString());
    }
  }

  Charge charge() {
    dynamic meta = {
      "client_id": UserController.instance.user.value.id,
      "the_package_id": widget.packageId
    };
    print('the meta $meta');

    return Charge(
      // amount: (subTotal * 100).toInt() + (deliveryFee * 100).toInt(),
      amount: (deliveryFee * 100).toInt(),
      publicKey: squadPublicKey,
      email: "$userEmail",
      currencyCode: currency,
      transactionRef: "BENJI-PYM-${generateRandomString(10)}",
      paymentChannels: ["card", "bank", "ussd", "transfer"],
      customerName: "$userFirstName $userLastName",
      callbackUrl: null,
      metadata: meta,
      passCharge: true,
    );
  }

  String generateRandomString(int len) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(
        len,
        (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
      ),
    );
  }

  getUserData() async {
    AuthController.instance.checkIfAuthorized();
    var user = UserController.instance.user.value;
    setState(() {
      userFirstName = user.firstName;
      userLastName = user.lastName;
      userEmail = user.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(
          title: "Payout",
          elevation: 0,
          actions: const [],
          backgroundColor: kPrimaryColor,
        ),
        bottomNavigationBar: Container(
          width: media.width,
          padding: const EdgeInsets.all(kDefaultPadding),
          decoration: BoxDecoration(color: kPrimaryColor),
          child: MyElevatedButton(
            title: "Pay - ₦${doubleFormattedText(totalPrice)}",
            onPressed: placeOrder,
          ),
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Scrollbar(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(kDefaultPadding),
              controller: scrollController,
              children: [
                Lottie.asset(
                  "assets/animations/delivery/frame_2.json",
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                ),
                kSizedBox,
                const Text(
                  'Package Summary',
                  style: TextStyle(
                    color: kTextBlackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                kSizedBox,
                Container(
                  width: media.width,
                  decoration: ShapeDecoration(
                    color: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x0F000000),
                        blurRadius: 24,
                        offset: Offset(0, 4),
                        spreadRadius: 7,
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    itemCount: titles.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(height: 1, color: kGreyColor1),
                    itemBuilder: (BuildContext context, int index) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: media.width - 250,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: kLightGreyColor),
                        child: Text(
                          titles[index],
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                            color: kTextBlackColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      trailing: Container(
                        width: media.width - 250,
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          packageData![index],
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            color: kSecondaryColor,
                            fontSize: 12,
                            fontFamily: 'sen',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                kSizedBox,
                Container(
                  width: media.width,
                  padding: const EdgeInsets.all(kDefaultPadding),
                  decoration: ShapeDecoration(
                    color: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x0F000000),
                        blurRadius: 24,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        child: Text(
                          'Payment Summary',
                          style: TextStyle(
                            color: kTextBlackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Divider(height: 20, color: kGreyColor1),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Delivery Fee',
                                style: TextStyle(
                                  color: kTextBlackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '₦${intFormattedText(deliveryFee)}',
                                style: TextStyle(
                                  color: kTextGreyColor,
                                  fontSize: 16,
                                  fontFamily: 'Sen',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          kSizedBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Service Fee',
                                style: TextStyle(
                                  color: kTextBlackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '₦${doubleFormattedText(serviceFee)}',
                                style: TextStyle(
                                  color: kTextGreyColor,
                                  fontSize: 16,
                                  fontFamily: 'Sen',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      kHalfSizedBox,
                      const Divider(height: 4, color: kGreyColor1),
                      kHalfSizedBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              color: kSecondaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '₦${doubleFormattedText(totalPrice)}',
                            style: TextStyle(
                              color: kSecondaryColor,
                              fontSize: 16,
                              fontFamily: 'Sen',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
