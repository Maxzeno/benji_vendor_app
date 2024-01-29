import 'package:benji_vendor/src/components/appbar/my_appbar.dart';
import 'package:benji_vendor/src/components/button/my%20elevatedButton.dart';
import 'package:benji_vendor/src/components/input/my_blue_textformfield.dart';
import 'package:benji_vendor/src/components/input/my_textformfield.dart';
import 'package:benji_vendor/src/controller/form_controller.dart';
import 'package:benji_vendor/src/controller/user_controller.dart';
import 'package:benji_vendor/src/controller/withdraw_controller.dart';
import 'package:benji_vendor/src/model/validate_bank_account.dart';
import 'package:benji_vendor/src/providers/api_url.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../src/providers/constants.dart';
import '../../theme/colors.dart';
import 'select_bank.dart';

class AddBankAccountPage extends StatefulWidget {
  const AddBankAccountPage({super.key});

  @override
  State<AddBankAccountPage> createState() => _AddBankAccountPageState();
}

class _AddBankAccountPageState extends State<AddBankAccountPage> {
//===================================== INITIAL STATE =========================================\\
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

//===================================== ALL VARIABLES =========================================\\

//===================================== BOOL VALUES =========================================\\
  bool isVisible = false;

//================= Controllers ==================\\
  final scrollController = ScrollController();
  final bankNameEC = TextEditingController();
  final accountNumberEC = TextEditingController();

//================= Focus Nodes ==================\\
  final bankNameFN = FocusNode();
  final bankNames = FocusNode();
  final accountNumberFN = FocusNode();

  final formKey = GlobalKey<FormState>();

  String bankCode = "";

  //================================== FUNCTION ====================================\\

  //=================================== Navigation ============================\\
  selectBank() async {
    final result = await Get.to(
      () => const SelectBank(),
      routeName: 'SelectBank',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.downToUp,
    );
    if (result != null) {
      final newBankName = result['name'];
      final newBankCode = result['code'];

      setState(() {
        bankNameEC.text = newBankName;
        bankCode = newBankCode;
      });
    }
  }

  saveAccount(ValidateBankAccountModel data) async {
    Map body = {
      'user_id': UserController.instance.user.value.id.toString(),
      'bank_name': bankNameEC.text,
      'bank_code': data.responseBody.bankCode,
      'account_holder': data.responseBody.accountName,
      'account_number': data.responseBody.accountNumber,
    };

    await FormController.instance.postAuth(
        '${Api.baseUrl}/payments/saveBankDetails',
        body,
        'saveBankDetails',
        'Error occured',
        'Added successfully');

    if (FormController.instance.status.value == 200) {
      Get.close(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: MyAppBar(
          title: "Add bank account",
          elevation: 0,
          actions: const [],
          backgroundColor: kPrimaryColor,
        ),
        bottomNavigationBar:
            GetBuilder<WithdrawController>(builder: (controller) {
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: kAccentColor.withOpacity(0.08),
                offset: const Offset(3, 0),
                blurRadius: 32,
              ),
            ]),
            child: Obx(
              () => MyElevatedButton(
                title: "Save Account",
                onPressed: !controller
                            .validateAccount.value.requestSuccessful ||
                        accountNumberEC.text.length < 10
                    ? null
                    : () async {
                        if (formKey.currentState!.validate()) {
                          await saveAccount(controller.validateAccount.value);
                        }
                      },
                isLoading: FormController.instance.isLoad.value,
              ),
            ),
          );
        }),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kDefaultPadding),
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bank Name',
                    style: TextStyle(
                      color: kTextGreyColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  kHalfSizedBox,
                  GetBuilder<WithdrawController>(
                    builder: (controller) {
                      return InkWell(
                        onTap: controller.listOfBanks.isEmpty &&
                                controller.isLoad.value
                            ? null
                            : selectBank,
                        child: MyBlueTextFormField(
                          controller: bankNameEC,
                          isEnabled: false,
                          textInputAction: TextInputAction.next,
                          focusNode: bankNameFN,
                          hintText: controller.listOfBanks.isEmpty &&
                                  controller.isLoad.value
                              ? "Loading..."
                              : "Select a bank",
                          suffixIcon: FaIcon(
                            FontAwesomeIcons.chevronDown,
                            size: 20,
                            color: kAccentColor,
                          ),
                          textInputType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value!.isEmpty) {
                              return "Select a bank";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              bankNameEC.text = value!;
                            });
                          },
                        ),
                      );
                    },
                  ),
                  kSizedBox,
                  Text(
                    'Account Number',
                    style: TextStyle(
                      color: kTextGreyColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  kHalfSizedBox,
                  MyTextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: accountNumberEC,
                    focusNode: accountNumberFN,
                    hintText: "Enter the account number here",
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.name,
                    onChanged: (value) {
                      if (value.length >= 10) {
                        WithdrawController.instance.validateBankNumbers(
                            accountNumberEC.text, bankCode);
                      }
                      setState(() {});
                    },
                    validator: (value) {
                      if (value == null || value!.isEmpty) {
                        accountNumberFN.requestFocus();
                        return "Enter the account number";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      accountNumberEC.text = value!;
                    },
                  ),
                  kSizedBox,
                  GetBuilder<WithdrawController>(builder: (controller) {
                    if (controller.isLoadValidateAccount.value) {
                      return Text(
                        'Loading...',
                        style: TextStyle(
                          color: kAccentColor.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }
                    if (accountNumberEC.text.length < 10) {
                      return const Text('');
                    }
                    return Text(
                      controller.validateAccount.value.requestSuccessful
                          ? controller
                              .validateAccount.value.responseBody.accountName
                          : 'Bank details not found',
                      style: TextStyle(
                        color: kAccentColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
