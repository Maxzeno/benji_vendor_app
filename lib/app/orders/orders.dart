import 'package:benji_vendor/app/orders/order_details.dart';
import 'package:benji_vendor/src/components/card/empty.dart';
import 'package:benji_vendor/src/components/container/business_order_container.dart';
import 'package:benji_vendor/src/controller/order_controller.dart';
import 'package:benji_vendor/src/model/business_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../src/controller/auth_controller.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

enum StatusType {
  pending,
  dispatched,
  processing,
  confirmed,
  delivered,
  cancelled
}

class Orders extends StatefulWidget {
  const Orders({super.key, required this.business});
  final BusinessModel business;

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  //===== variable =====//

  @override
  void initState() {
    super.initState();
    AuthController.instance.checkIfAuthorized();
    scrollController.addListener(() => OrderController.instance
        .scrollListener(scrollController, widget.business.id));
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  void clickPending() async {
    await OrderController.instance
        .setStatus(widget.business.id, StatusType.pending);
  }

  void clickDispatched() async {
    await OrderController.instance
        .setStatus(widget.business.id, StatusType.dispatched);
  }

  void clickDelivered() async {
    await OrderController.instance
        .setStatus(widget.business.id, StatusType.delivered);
  }

  void clickCancelled() async {
    await OrderController.instance
        .setStatus(widget.business.id, StatusType.cancelled);
  }

  bool checkStatus(StatusType? theStatus, StatusType currentStatus) =>
      theStatus == currentStatus;

  //========= variables ==========//
  bool isScrollToTopBtnVisible = false;

  final ScrollController scrollController = ScrollController();

  //===================== Scroll to Top ==========================\\
  Future<void> scrollToTop() async {
    await scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {
      isScrollToTopBtnVisible = false;
    });
  }

  Future<void> _scrollListener() async {
    if (scrollController.position.pixels >= 100 &&
        isScrollToTopBtnVisible != true) {
      setState(() {
        isScrollToTopBtnVisible = true;
      });
    }
    if (scrollController.position.pixels < 100 &&
        isScrollToTopBtnVisible == true) {
      setState(() {
        isScrollToTopBtnVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // var media = MediaQuery.of(context).size;
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(kDefaultPadding),
      physics: const BouncingScrollPhysics(),
      controller: scrollController,
      children: [
        GetBuilder<OrderController>(
          builder: (controller) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        checkStatus(controller.status.value, StatusType.pending)
                            ? kAccentColor
                            : const Color(0xFFF2F2F2),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                  ),
                  onPressed: clickPending,
                  child: Text(
                    'Pending',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: checkStatus(
                              controller.status.value, StatusType.pending)
                          ? kPrimaryColor
                          : kGreyColor2,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                kHalfWidthSizedBox,
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: checkStatus(
                            controller.status.value, StatusType.dispatched)
                        ? kAccentColor
                        : const Color(0xFFF2F2F2),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                  ),
                  onPressed: clickDispatched,
                  child: Text(
                    'Dispatched',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: checkStatus(
                              controller.status.value, StatusType.dispatched)
                          ? kPrimaryColor
                          : kGreyColor2,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                kHalfWidthSizedBox,
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: checkStatus(
                            controller.status.value, StatusType.delivered)
                        ? kAccentColor
                        : const Color(0xFFF2F2F2),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                  ),
                  onPressed: clickDelivered,
                  child: Text(
                    'Delivered',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: checkStatus(
                              controller.status.value, StatusType.delivered)
                          ? kPrimaryColor
                          : kGreyColor2,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(width: 15),

                // const SizedBox(width: 15),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: checkStatus(
                //             controller.status.value, StatusType.cancelled)
                //         ? kAccentColor
                //         : kDefaultCategoryBackgroundColor,
                //     shape: const RoundedRectangleBorder(
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(16),
                //       ),
                //     ),
                //   ),
                //   onPressed: clickCancelled,
                //   child: Text(
                //     'Cancelled',
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //       color: checkStatus(controller.status.value,
                //               StatusType.cancelled)
                //           ? kPrimaryColor
                //           : kGreyColor2,
                //       fontSize: 14,
                //       fontWeight: FontWeight.w400,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
        kSizedBox,
        GetBuilder<OrderController>(
          builder: (controller) =>
              controller.isLoad.value && controller.vendorsOrderList.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(color: kAccentColor),
                    )
                  : controller.vendorsOrderList.isEmpty
                      ? const EmptyCard(
                          emptyCardMessage: "There are no orders here")
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: controller.vendorsOrderList.length,
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (context, index) => kSizedBox,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Get.to(
                                  () => OrderDetails(
                                    business: widget.business,
                                    order: controller.vendorsOrderList[index],
                                    orderStatus: controller
                                                .vendorsOrderList[index]
                                                .deliveryStatus ==
                                            "COMP"
                                        ? "Completeds"
                                        : controller.vendorsOrderList[index]
                                                    .deliveryStatus ==
                                                "dispatched"
                                            ? "Dispatched"
                                            : controller.vendorsOrderList[index]
                                                        .deliveryStatus ==
                                                    "PEND"
                                                ? "Pending"
                                                : "Completed",
                                    orderStatusColor: controller
                                                .vendorsOrderList[index]
                                                .deliveryStatus ==
                                            "CANC"
                                        ? kAccentColor
                                        : controller.vendorsOrderList[index]
                                                    .deliveryStatus ==
                                                "dispatched"
                                            ? kSecondaryColor
                                            : controller.vendorsOrderList[index]
                                                        .deliveryStatus ==
                                                    "PEND"
                                                ? kLoadingColor
                                                : kSuccessColor,
                                  ),
                                  routeName: 'OrderDetails',
                                  duration: const Duration(milliseconds: 300),
                                  fullscreenDialog: true,
                                  curve: Curves.easeIn,
                                  preventDuplicates: true,
                                  popGesture: true,
                                  transition: Transition.rightToLeft,
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              mouseCursor: SystemMouseCursors.click,
                              child: BusinessOrderContainer(
                                order: controller.vendorsOrderList[index],
                              ),
                            );
                          },
                        ),
        ),
        kSizedBox,
        GetBuilder<OrderController>(
          builder: (controller) => Column(
            children: [
              controller.isLoadMore.value
                  ? Center(
                      child: CircularProgressIndicator(color: kAccentColor),
                    )
                  : const SizedBox(),
              controller.loadedAll.value &&
                      controller.vendorsOrderList.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 20, bottom: 20),
                          height: 10,
                          width: 10,
                          decoration: ShapeDecoration(
                              shape: const CircleBorder(),
                              color: kPageSkeletonColor),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
