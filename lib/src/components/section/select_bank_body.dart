
import 'package:benji_vendor/src/components/card/empty.dart';
import 'package:benji_vendor/src/components/section/bank_list_tile.dart';
import 'package:benji_vendor/src/controller/withdraw_controller.dart';
import 'package:benji_vendor/src/model/bank_model.dart';
import 'package:benji_vendor/src/providers/constants.dart';
import 'package:benji_vendor/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SelectBankBody extends StatefulWidget {
  final banks = Get.put(WithdrawController());

  SelectBankBody({super.key});

  @override
  State<SelectBankBody> createState() => _SelectBankBodyState();
}

class _SelectBankBodyState extends State<SelectBankBody> {
    List<BankModel> listOfBanksSearch = WithdrawController.instance.listOfBanks;

  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //==================  CONTROLLERS ==================\\
  final scrollController = ScrollController();
  final bankQueryEC = TextEditingController();
 
  //================== FUNCTIONS ==================\\

  void onChanged(String search) {
    List<BankModel> list = WithdrawController.instance.listOfBanks;

    if (search.isEmpty) {
      setState(() {
        listOfBanksSearch = list;
      });
    } else {
      listOfBanksSearch = list
          .where((bank) {
            return bank.name.toLowerCase().contains(search);
            })
          .toList();
          setState(() {
            
          });
    }
  }


  selectBank(index) async {
    final newBankName = listOfBanksSearch[index].name;
    final newBankCode = listOfBanksSearch[index].code;

    bankQueryEC.text = newBankName;

    final result = {'name': newBankName, 'code': newBankCode};

    Get.back(result: result);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SearchBar(constraints: const BoxConstraints.tightFor(),
              padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
              controller: bankQueryEC,
              hintText: "Search bank",
              backgroundColor: MaterialStatePropertyAll(
                  Theme.of(context).scaffoldBackgroundColor),
              elevation: const MaterialStatePropertyAll(0),
              leading: FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                color: kAccentColor,
                size: 20,
              ),
              onChanged: onChanged,
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )),
              side:
                  MaterialStatePropertyAll(BorderSide(color: kLightGreyColor)),
            ),
          ),
          Expanded(
            child: listOfBanksSearch.isEmpty
                      ? const EmptyCard(
                          emptyCardMessage: "There are no banks",
                        )
                      
                      : ListView.separated(
                        controller: scrollController,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(10),
                          itemCount: listOfBanksSearch.length,
                          separatorBuilder: (context, index) => kSizedBox,
                          itemBuilder: (context, index) {
                            final bankName = listOfBanksSearch[index].name;
                              return BankListTile(
                                onTap: () => selectBank(index),
                                bank: bankName,
                              );
                          },
                        ),
          ),
        ],
      ),
    );
  }
}

