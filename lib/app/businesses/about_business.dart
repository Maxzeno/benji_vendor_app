import 'package:benji_vendor/app/businesses/user_reviews.dart';
import 'package:benji_vendor/src/components/container/available_cashback_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../src/components/card/customer_review_card.dart';
import '../../src/components/card/empty.dart';
import '../../src/model/business_model.dart';
import '../../src/model/rating_model.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

class AboutBusiness extends StatefulWidget {
  final BusinessModel business;
  const AboutBusiness({
    super.key,
    required this.business,
  });

  @override
  State<AboutBusiness> createState() => _AboutBusinessState();
}

class _AboutBusinessState extends State<AboutBusiness> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  final List<String> stars = ['5', '4', '3', '2', '1'];
  String active = 'all';

  List<Ratings>? _ratings = [];
  _getData() async {
    setState(() {
      _ratings = null;
    });

    List<Ratings> ratings;
    if (active == 'all') {
      ratings = await getRatingsByVendorId(widget.business.id);
    } else {
      ratings = await getRatingsByVendorIdAndRating(
          widget.business.id, int.parse(active));
    }

    setState(() {
      _ratings = ratings;
    });
  }

  void _viewAllReviews() => Get.to(
        () => UserReviewsPage(
          business: widget.business,
        ),
        routeName: 'UserReviewsPage',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    // double mediaHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.all(kDefaultPadding / 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvailableCashbackCard(business: widget.business),
          kSizedBox,
          const Text(
            "About This Business",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          kSizedBox,
          Container(
            width: mediaWidth,
            padding: const EdgeInsets.all(kDefaultPadding),
            decoration: ShapeDecoration(
              color: const Color(0xFFFEF8F8),
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 0.50,
                  color: Color(0xFFFDEDED),
                ),
                borderRadius: BorderRadius.circular(25),
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
            child: Text(
              widget.business.shopType.isBlank == true
                  ? 'Not Available'
                  : widget.business.shopType.description,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          kSizedBox,
          const Text(
            "Working Hours",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          kSizedBox,
          Container(
            width: mediaWidth,
            padding: const EdgeInsets.all(kDefaultPadding),
            decoration: ShapeDecoration(
              color: const Color(0xFFFEF8F8),
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 0.50,
                  color: Color(0xFFFDEDED),
                ),
                borderRadius: BorderRadius.circular(25),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Mon. - Fri.",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        kHalfWidthSizedBox,
                        const Text(
                          " - ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "${widget.business.weekOpeningHours} - ${widget.business.weekClosingHours}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    kHalfSizedBox,
                    Row(
                      children: [
                        const Text(
                          "Sat.",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        kHalfWidthSizedBox,
                        const Text(
                          " - ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "${widget.business.satOpeningHours} - ${widget.business.satClosingHours}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    kHalfSizedBox,
                    Row(
                      children: [
                        const Text(
                          "Sun.",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        kHalfWidthSizedBox,
                        const Text(
                          " - ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "${widget.business.sunWeekOpeningHours} - ${widget.business.sunWeekClosingHours}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          kSizedBox,
          Container(
            width: mediaWidth,
            padding: const EdgeInsets.all(kDefaultPadding),
            decoration: ShapeDecoration(
              color: const Color(0xFFFEF8F8),
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 0.50,
                  color: Color(0xFFFDEDED),
                ),
                borderRadius: BorderRadius.circular(25),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Reviews View & Ratings",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding,
                    horizontal: kDefaultPadding * 0.5,
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: active == 'all'
                                  ? kAccentColor
                                  : const Color(
                                      0xFFA9AAB1,
                                    ),
                            ),
                            backgroundColor:
                                active == 'all' ? kAccentColor : kPrimaryColor,
                            foregroundColor: active == 'all'
                                ? kPrimaryColor
                                : const Color(0xFFA9AAB1),
                          ),
                          onPressed: () async {
                            active = 'all';
                            setState(() {
                              _ratings = null;
                            });

                            List<Ratings> ratings =
                                await getRatingsByVendorId(widget.business.id);

                            setState(() {
                              _ratings = ratings;
                            });
                          },
                          child: const Text(
                            'All',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Row(
                          children: stars
                              .map(
                                (item) => Row(
                                  children: [
                                    kHalfWidthSizedBox,
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: active == item
                                              ? kStarColor
                                              : const Color(0xFFA9AAB1),
                                        ),
                                        foregroundColor: active == item
                                            ? kStarColor
                                            : const Color(0xFFA9AAB1),
                                      ),
                                      onPressed: () async {
                                        active = item;

                                        setState(() {
                                          _ratings = null;
                                        });

                                        List<Ratings> ratings =
                                            await getRatingsByVendorIdAndRating(
                                                widget.business.id,
                                                int.parse(active));

                                        setState(() {
                                          _ratings = ratings;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.solidStar,
                                            size: 20,
                                            color: kStarColor,
                                          ),
                                          const SizedBox(
                                            width: kDefaultPadding * 0.2,
                                          ),
                                          Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                        kHalfWidthSizedBox,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          kSizedBox,
          _ratings == null
              ? Center(
                  child: CircularProgressIndicator(
                  color: kAccentColor,
                ))
              : _ratings!.isEmpty
                  ? const EmptyCard(
                      showButton: false,
                    )
                  : Column(
                      children: [
                        ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (context, index) => kSizedBox,
                          shrinkWrap: true,
                          itemCount: _ratings!.length,
                          itemBuilder: (BuildContext context, int index) =>
                              CostumerReviewCard(rating: _ratings![index]),
                        ),
                        kSizedBox,
                        _ratings!.isEmpty
                            ? const SizedBox()
                            : TextButton(
                                onPressed: _viewAllReviews,
                                child: Text(
                                  "See all",
                                  style: TextStyle(
                                    color: kAccentColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                        kSizedBox,
                      ],
                    ),
        ],
      ),
    );
  }
}
