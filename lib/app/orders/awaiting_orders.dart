import 'package:benji_vendor/app/orders/order_detail_await.dart';
import 'package:benji_vendor/src/components/appbar/my_appbar.dart';
import 'package:benji_vendor/src/components/card/empty.dart';
import 'package:benji_vendor/src/components/container/business_order_container.dart';
import 'package:benji_vendor/src/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../src/controller/auth_controller.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

class OrdersAwaiting extends StatefulWidget {
  const OrdersAwaiting({super.key});

  @override
  State<OrdersAwaiting> createState() => _OrdersAwaitingState();
}

class _OrdersAwaitingState extends State<OrdersAwaiting> {
  //===== variable =====//

  @override
  void initState() {
    super.initState();
    AuthController.instance.checkIfAuthorized();
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    // var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(
        title: "Orders awaiting confirmation",
        elevation: 0,
        actions: const [],
        backgroundColor: kPrimaryColor,
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(kDefaultPadding),
          physics: const BouncingScrollPhysics(),
          controller: scrollController,
          children: [
            GetBuilder<OrderController>(
              initState: (_) => OrderController.instance.getOrdersAwait(),
              builder: (controller) => controller.isLoadAwait.value &&
                      controller.vendorsOrderAwaitList.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(color: kAccentColor),
                    )
                  : controller.vendorsOrderAwaitList.isEmpty
                      ? const EmptyCard(
                          emptyCardMessage: "There are no orders here")
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: controller.vendorsOrderAwaitList.length,
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (context, index) => kSizedBox,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Get.to(
                                  () => OrderDetailsAwait(
                                    order:
                                        controller.vendorsOrderAwaitList[index],
                                  ),
                                  routeName: 'OrderDetailsAwait',
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
                                order: controller.vendorsOrderAwaitList[index],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
