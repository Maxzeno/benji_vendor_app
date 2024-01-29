// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'package:benji_vendor/app/withdrawal/select_account.dart';
import 'package:benji_vendor/main.dart';
import 'package:benji_vendor/src/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';

import '../../../theme/colors.dart';
import '../../providers/constants.dart';

class ProfileFirstHalf extends StatefulWidget {
  const ProfileFirstHalf({super.key});

  @override
  State<ProfileFirstHalf> createState() => _ProfileFirstHalfState();
}

class _ProfileFirstHalfState extends State<ProfileFirstHalf> {
//======================================================= INITIAL STATE ================================================\\
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
//======================================================= ALL VARIABLES ================================================\\

//======================================================= FUNCTIONS ================================================\\

// logic
  Future<void> toggleVisibleCash() async {
    bool isVisibleCash = prefs.getBool('isVisibleCash') ?? true;
    await prefs.setBool('isVisibleCash', !isVisibleCash);

    UserController.instance.setUserSync();
  }

  void toSelectAccount() => Get.to(
        () => const SelectAccountPage(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "SelectAccountPage",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.cupertinoDialog,
      );
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      decoration: ShapeDecoration(
        color: kAccentColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Available Cashback',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              GetBuilder<UserController>(
                builder: (controller) => IconButton(
                  onPressed: toggleVisibleCash,
                  icon: FaIcon(
                    controller.user.value.isVisibleCash
                        ? FontAwesomeIcons.solidEye
                        : FontAwesomeIcons.solidEyeSlash,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          kSizedBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GetBuilder<UserController>(
                init: UserController(),
                // initState: (state) {
                //   state.controller!.getUser();
                // },
                builder: (controller) => controller.isLoading.value
                    ? Text(
                        'Loading...',
                        style: TextStyle(
                          color: kTextWhiteColor.withOpacity(0.8),
                          fontSize: 20,
                          fontFamily: 'sen',
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "₦",
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 20,
                                fontFamily: 'sen',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: controller.user.value.isVisibleCash
                                  ? doubleFormattedText(
                                      controller.user.value.balance)
                                  : '******',
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.arrowsRotate),
                onPressed: () async {
                  await UserController.instance.getUser();
                },
                color: kTextWhiteColor.withOpacity(0.8),
                iconSize: 25.0,
                tooltip: 'Refresh',
                padding: const EdgeInsets.all(10.0),
                splashRadius: 20.0,
              ),
            ],
          ),
          kSizedBox,
          InkWell(
            onTap: toSelectAccount,
            child: Container(
              width: 100,
              height: 37,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 0.50,
                    color: kPrimaryColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  'Withdraw',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: kDefaultPadding * 2,
          ),
        ],
      ),
    );
  }
}
