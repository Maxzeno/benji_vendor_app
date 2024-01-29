import 'package:benji_vendor/src/components/appbar/my_appbar.dart';
import 'package:benji_vendor/src/components/card/empty.dart';
import 'package:benji_vendor/src/components/withdrawal_detail_card.dart';
import 'package:benji_vendor/src/controller/withdraw_controller.dart';
import 'package:benji_vendor/src/providers/responsive_constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

class WithdrawalHistoryPage extends StatefulWidget {
  const WithdrawalHistoryPage({super.key});

  @override
  State<WithdrawalHistoryPage> createState() => _WithdrawalHistoryPageState();
}

class _WithdrawalHistoryPageState extends State<WithdrawalHistoryPage> {
//===================================== INITIAL STATE AND DISPOSE =========================================\\
  @override
  void initState() {
    super.initState();
    WithdrawController.instance.withdrawalHistory();
    scrollController.addListener(_scrollListener);
  }

//===================================== ALL VARIABLES =========================================\\

//============================================== BOOL VALUES =================================================\\
  bool _isScrollToTopBtnVisible = false;
  bool loadingScreen = false;

  //==================================================== CONTROLLERS ======================================================\\
  final scrollController = ScrollController();

//===================================== FUNCTIONS =========================================\\
//===================== Handle refresh ==========================\\

  Future<void> handleRefresh() async {
    scrollController.addListener(_scrollListener);
    setState(() {
      loadingScreen = true;
    });
    await WithdrawController.instance.withdrawalHistory();
    setState(() {
      loadingScreen = false;
    });
  }

  //===================== Scroll to Top ==========================\\
  Future<void> _scrollToTop() async {
    await scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {
      _isScrollToTopBtnVisible = false;
    });
  }

  Future<void> _scrollListener() async {
    if (scrollController.position.pixels >= 100 &&
        _isScrollToTopBtnVisible != true) {
      setState(() {
        _isScrollToTopBtnVisible = true;
      });
    }
    if (scrollController.position.pixels < 100 &&
        _isScrollToTopBtnVisible == true) {
      setState(() {
        _isScrollToTopBtnVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: MyAppBar(
        title: "Withdrawal History",
        elevation: 0.0,
        actions: const [],
        backgroundColor: kPrimaryColor,
      ),
      floatingActionButton: _isScrollToTopBtnVisible
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              mini: deviceType(media.width) > 2 ? false : true,
              backgroundColor: kAccentColor,
              enableFeedback: true,
              mouseCursor: SystemMouseCursors.click,
              tooltip: "Scroll to top",
              hoverColor: kAccentColor,
              hoverElevation: 50.0,
              child: const FaIcon(FontAwesomeIcons.chevronUp, size: 18),
            )
          : const SizedBox(),
      body: SafeArea(
        child: Scrollbar(
          controller: scrollController,
          child: GetBuilder<WithdrawController>(
            initState: (state) =>
                WithdrawController.instance.withdrawalHistory(),
            builder: (detail) {
              if (detail.listOfWithdrawals.isEmpty && detail.isLoad.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: kAccentColor,
                  ),
                );
              }
              if (detail.listOfWithdrawals.isEmpty) {
                return const Center(child: EmptyCard());
              }

              return ListView.separated(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: detail.listOfWithdrawals.length,
                padding: const EdgeInsets.all(30),
                separatorBuilder: (context, index) => kSizedBox,
                itemBuilder: (context, index) {
                  return WithdrawalDetailCard(
                    withdrawalDetail: detail.listOfWithdrawals[index],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
