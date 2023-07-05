// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../modules/product/category button section.dart';
import '../../theme/colors.dart';
import '../../theme/constants.dart';

class ViewProduct extends StatefulWidget {
  const ViewProduct({super.key});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  //============================ ALL VARIABLES ===============================\\

  //============================== CATEGORY BUTTONS ===========================\\
  final List _categoryButtonText = [
    "Protein",
    "Stew Type",
    "",
    "",
    "",
  ];

  final List<Color> _categoryButtonBgColor = [
    kAccentColor,
    const Color(
      0xFFF2F2F2,
    ),
    const Color(
      0xFFF2F2F2,
    ),
    const Color(
      0xFFF2F2F2,
    ),
    const Color(
      0xFFF2F2F2,
    ),
  ];
  final List<Color> _categoryButtonFontColor = [
    kPrimaryColor,
    const Color(
      0xFF828282,
    ),
    const Color(
      0xFF828282,
    ),
    const Color(
      0xFF828282,
    ),
    const Color(
      0xFF828282,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white.withOpacity(
          0.6,
        ),
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 320,
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    "assets/images/food/pasta.png",
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.04,
            left: kDefaultPadding,
            right: kDefaultPadding,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(context);
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: ShapeDecoration(
                        color: const Color(
                          0xFFFAFAFA,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            19,
                          ),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: ShapeDecoration(
                        color: const Color(
                          0xFFFAFAFA,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            19,
                          ),
                        ),
                      ),
                      child: const Icon(
                        Icons.more_horiz_rounded,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 380,
            left: kDefaultPadding,
            right: kDefaultPadding,
            child: Container(
              height: MediaQuery.of(context).size.height - 400,
              width: MediaQuery.of(context).size.width,
              // color: kAccentColor,
              padding: const EdgeInsets.all(
                5.0,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Smokey Jollof Rice",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(
                              0xFF302F3C,
                            ),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "₦850",
                          style: TextStyle(
                            color: Color(
                              0xFF333333,
                            ),
                            fontSize: 22,
                            fontFamily: 'sen',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    kSizedBox,
                    const Text(
                      "This is a short description about the food you mentoned which is a restaurant food in this case.",
                      style: TextStyle(
                        color: Color(
                          0xFF676565,
                        ),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    kSizedBox,
                    const SizedBox(
                      width: 67,
                      height: 17,
                      child: Text(
                        'Qty: 3200',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(
                            0xFF828282,
                          ),
                          fontSize: 13.60,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    kSizedBox,
                    CategoryButtonSection(
                      category: _categoryButtonText,
                      categorybgColor: _categoryButtonBgColor,
                      categoryFontColor: _categoryButtonFontColor,
                    ),
                    kSizedBox,
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Beef (₦2,000)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Sen',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        kSizedBox,
                        Text(
                          'Fish (₦2,000)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Sen',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        kSizedBox,
                        Text(
                          'Goat Meat (₦2,000)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Sen',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        kSizedBox,
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
