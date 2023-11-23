// ignore_for_file: file_names

import 'package:benji_vendor/src/components/responsive_widgets/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../src/components/appbar/my appbar.dart';
import '../../src/components/button/my elevatedButton.dart';
import '../../src/controller/form_controller.dart';
import '../../src/controller/push_notifications_controller.dart';
import '../../src/model/order_model.dart';
import '../../src/providers/api_url.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

class OrderDetails extends StatefulWidget {
  final OrderModel order;
  final String orderStatus;
  final Color orderStatusColor;

  const OrderDetails(
      {super.key,
      required this.order,
      required this.orderStatus,
      required this.orderStatusColor});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  void initState() {
    super.initState();
  }

//============================== ALL VARIABLES ================================\\
  bool isDispatched = false;
  String dispatchMessage = "Your order has been dispatched";

//============================== FUNCTIONS ================================\\
  orderDispatched() async {
    HapticFeedback.selectionClick();
    Map<String, dynamic> data = {
      "delivery_status": "dispatched",
    };

    var url =
        "${Api.baseUrl}${Api.changeOrderStatus}?order_id=${widget.order.id}&display_message=$dispatchMessage";
    consoleLog(url);
    consoleLog(data.toString());
    await FormController.instance.patchAuth(url, data, 'dispatchOrder');
    if (FormController.instance.status.toString().startsWith('2')) {
      await PushNotificationController.showNotification(
        title: "Success",
        body: dispatchMessage,
        summary: "Package Delivery",
        largeIcon: "asset://assets/icons/package.png",
      );
      setState(() {
        isDispatched = true;
      });
      await Future.delayed(const Duration(microseconds: 500), () {
        Get.close(1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return MyResponsivePadding(
      child: Scaffold(
        appBar: MyAppBar(
          title: "Order Details",
          elevation: 0,
          actions: const [],
          backgroundColor: kPrimaryColor,
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: isDispatched == false && widget.orderStatus == "Pending"
              ? GetBuilder<FormController>(
                  init: FormController(),
                  builder: (controller) {
                    return MyElevatedButton(
                      title: "Dispatched",
                      onPressed: orderDispatched,
                      isLoading: controller.isLoad.value,
                    );
                  },
                )
              : const SizedBox(),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(kDefaultPadding),
          children: <Widget>[
            Container(
              width: media.width,
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              decoration: ShapeDecoration(
                color: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.30),
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
              child: SizedBox(
                width: media.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Oder ID',
                          style: TextStyle(
                            color: kTextGreyColor,
                            fontSize: 11.62,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          widget.order.created,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: kTextBlackColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    kHalfSizedBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.order.code,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: kTextBlackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.32,
                          ),
                        ),

                        Text(
                          widget.orderStatus,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: widget.orderStatusColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.32,
                          ),
                        )
                        // widget.order.deliveryStatus == "COMP"
                        //     ? const Text(
                        //         'Delivered',
                        //         textAlign: TextAlign.right,
                        //         style: TextStyle(
                        //           color: kSuccessColor,
                        //           fontSize: 16,
                        //           fontWeight: FontWeight.w700,
                        //           letterSpacing: -0.32,
                        //         ),
                        //       )
                        //     : isDispatched == true &&
                        //             widget.order.deliveryStatus == "dispatched"
                        //         ? Text(
                        //             'Dispatched',
                        //             textAlign: TextAlign.right,
                        //             style: TextStyle(
                        //               color: kSecondaryColor,
                        //               fontSize: 16,
                        //               fontWeight: FontWeight.w700,
                        //               letterSpacing: -0.32,
                        //             ),
                        //           )
                        //         : isDispatched == false &&
                        //                 widget.order.deliveryStatus == "PEND"
                        //             ?
                        //             Text(
                        //                 'Canceled',
                        //                 textAlign: TextAlign.right,
                        //                 style: TextStyle(
                        //                   color: kAccentColor,
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.w700,
                        //                   letterSpacing: -0.32,
                        //                 ),
                        //               )

                        //             :  Text(
                        //                 'Pending',
                        //                 textAlign: TextAlign.right,
                        //                 style: TextStyle(
                        //                   color: kLoadingColor,
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.w700,
                        //                   letterSpacing: -0.32,
                        //                 ),
                        //               )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            kSizedBox,
            Container(
              width: media.width,
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              decoration: ShapeDecoration(
                color: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.30),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 24,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Items ordered',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kTextBlackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.32,
                    ),
                  ),
                  ListView.builder(
                    itemCount: widget.order.orderitems.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var adjustedIndex = index + 1;
                      var order = widget.order.orderitems[index];
                      return ListTile(
                        titleAlignment: ListTileTitleAlignment.center,
                        horizontalTitleGap: 0,
                        leading: Text(
                          "$adjustedIndex.",
                          style: const TextStyle(
                            color: kTextBlackColor,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        title: Text(
                          '${order.product.name} x ${order.quantity.toString()}',
                          style: const TextStyle(
                            color: kTextBlackColor,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            kSizedBox,
            Container(
              width: media.width,
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              decoration: ShapeDecoration(
                color: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 24,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Customer's Detail",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kTextBlackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.32,
                    ),
                  ),
                  kSizedBox,
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/images/profile/avatar-image.jpg"),
                          ),
                        ),
                        // child: CircleAvatar(
                        //   radius: deviceType(media.width) >= 2 ? 60 : 30,
                        //   child: ClipOval(
                        //     child: MyImage(url: widget.order.client.image),
                        //   ),
                        // ),
                      ),
                      kWidthSizedBox,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.order.client.firstName} ${widget.order.client.lastName}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: kTextBlackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          kHalfSizedBox,
                          Text(
                            widget.order.client.phone,
                            style: TextStyle(
                              color: kTextGreyColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          kHalfSizedBox,
                          // Text(
                          //   widget.order.deliveryAddress,
                          //   style: TextStyle(
                          //     color: kTextGreyColor,
                          //     fontSize: 12,
                          //     fontWeight: FontWeight.w400,
                          //   ),
                          // ),
                          // kHalfSizedBox,
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            kSizedBox,
            Container(
              width: media.width,
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              decoration: ShapeDecoration(
                color: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.30),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 24,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Summary',
                    style: TextStyle(
                      color: kTextBlackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.32,
                    ),
                  ),
                  kSizedBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          color: kTextBlackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: "₦ ",
                              style: TextStyle(
                                color: kTextBlackColor,
                                fontSize: 14,
                                fontFamily: 'Sen',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: convertToCurrency(
                                  widget.order.totalPrice.toString()),
                              style: const TextStyle(
                                color: kTextBlackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            // TextSpan(
                            //   text: widget.order.orderitems.totalAmount,
                            //   style: TextStyle(
                            //     color: kTextBlackColor,
                            //     fontSize: 14.30,
                            //     fontWeight: FontWeight.w400,
                            //   ),
                            // ),
                          ],
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  kHalfSizedBox,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
