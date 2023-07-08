// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../providers/constants.dart';
import '../theme/colors.dart';

class ReusableAuthenticationFirstHalf extends StatelessWidget {
  final String title;
  final String subtitle;
  final Decoration decoration;
  final double imageContainerHeight;
  const ReusableAuthenticationFirstHalf({
    super.key,
    required this.title,
    required this.subtitle,
    required this.decoration,
    required this.imageContainerHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: kDefaultPadding * 1.2,
            bottom: kDefaultPadding,
          ),
          child: Container(
            width: 88,
            height: imageContainerHeight,
            decoration: decoration,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 140,
          color: kSecondaryColor,
          child: Column(
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              kSizedBox,
              Padding(
                padding: const EdgeInsets.all(kDefaultPadding / 2),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
